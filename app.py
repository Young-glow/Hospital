from flask import Flask, render_template, request, jsonify, session, redirect, url_for
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
from datetime import datetime, date
import os
from dotenv import load_dotenv
from functools import wraps

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'ab0b643f3284a5f71ab12365258d6fd4be5c0600410364ac08c3afe7d1cd3096')
CORS(app)

# Змінна для відстеження останнього виконання валідації
last_validation_time = None

# Конфігурація бази даних
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'hospital_db'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', '2510'),
    'charset': 'utf8mb4',
    'collation': 'utf8mb4_unicode_ci'
}

def get_db_connection():
    """Створює та повертає підключення до бази даних"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Помилка підключення до MySQL: {e}")
        return None

# Декоратор для перевірки авторизації
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# Декоратор для перевірки ролі
def role_required(required_role):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                return redirect(url_for('login'))
            if session.get('role') != required_role:
                return redirect(url_for('dashboard'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# Головна сторінка - перенаправлення на логін або dashboard
@app.route('/')
def index():
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

# Сторінка логіну
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        login_data = request.json
        username = login_data.get('username')
        password = login_data.get('password')
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Помилка підключення до бази даних'}), 500
        
        try:
            cursor = conn.cursor(dictionary=True)
            query = """
                SELECT u.*, s.id as staff_id, s.first_name, s.last_name, s.middle_name, s.specialty_id
                FROM users u
                LEFT JOIN staff s ON u.staff_id = s.id
                WHERE u.login = %s AND u.password = %s
            """
            cursor.execute(query, (username, password))
            user = cursor.fetchone()
            
            if user:
                session['user_id'] = user['id']
                session['username'] = user['login']
                session['role'] = user['role']
                session['staff_id'] = user['staff_id']
                return jsonify({'success': True, 'role': user['role'], 'staff_id': user['staff_id']})
            else:
                return jsonify({'error': 'Невірний логін або пароль'}), 401
        except Error as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    
    return render_template('login.html')

# Вихід з системи
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# Dashboard - перенаправлення залежно від ролі
@app.route('/dashboard')
@login_required
def dashboard():
    validate_visits()
    role = session.get('role')
    
    if role == 'registrar':
        return redirect(url_for('registration'))
    elif role == 'doctor':
        staff_id = session.get('staff_id')
        if staff_id:
            return redirect(url_for('doctor', doctor_id=staff_id))
        else:
            session.clear()
            return redirect(url_for('login'))
    elif role == 'chief':
        return redirect(url_for('chief_doctor'))
    
    return redirect(url_for('login'))

# Валідація візитів - позначати незакриті візити як pending_closure
def validate_visits(force=False):
    global last_validation_time

    if not force and last_validation_time:
        time_diff = datetime.now() - last_validation_time
        if time_diff.total_seconds() < 43200:  # 12 годин
            return
    
    conn = get_db_connection()
    if not conn:
        return
    
    try:
        cursor = conn.cursor()
        query = """
            UPDATE visits 
            SET status = 'pending_closure'
            WHERE DATE(scheduled_start) < CURDATE()
            AND status = 'scheduled'
        """
        cursor.execute(query)
        rows_affected = cursor.rowcount
        conn.commit()
        last_validation_time = datetime.now()
        if rows_affected > 0:
            print(f"Валідація візитів: оновлено {rows_affected} візитів до статусу 'pending_closure'")
    except Error as e:
        print(f"Помилка валідації візитів: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

# Сторінка реєстрації пацієнтів
@app.route('/registration')
@role_required('registrar')
def registration():
    validate_visits()
    return render_template('registration.html')

# Отримати всіх пацієнтів
@app.route('/api/patients', methods=['GET'])
@login_required
def get_patients():
    search = request.args.get('search', '')
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        if search:
            query = """
                SELECT * FROM patients 
                WHERE last_name LIKE %s AND active = 1
                ORDER BY last_name, first_name
            """
            cursor.execute(query, (f'%{search}%',))
        else:
            query = "SELECT * FROM patients WHERE active = 1 ORDER BY last_name, first_name"
            cursor.execute(query)
        
        patients = cursor.fetchall()
        for patient in patients:
            if patient['birth_date']:
                patient['birth_date'] = patient['birth_date'].isoformat()
            if patient['created_at']:
                patient['created_at'] = patient['created_at'].isoformat()
            if patient['updated_at']:
                patient['updated_at'] = patient['updated_at'].isoformat()
        
        return jsonify(patients)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Створити нового пацієнта
@app.route('/api/patients', methods=['POST'])
@role_required('registrar')
def create_patient():
    data = request.json
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO patients (first_name, last_name, middle_name, birth_date, sex, phone, email, address)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (
            data['first_name'],
            data['last_name'],
            data.get('middle_name'),
            data.get('birth_date'),
            data.get('sex', 'O'),
            data.get('phone'),
            data.get('email'),
            data.get('address')
        ))
        conn.commit()
        return jsonify({'success': True, 'id': cursor.lastrowid})
    except Error as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати спеціальності
@app.route('/api/specialties', methods=['GET'])
def get_specialties():
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM specialties ORDER BY name")
        specialties = cursor.fetchall()
        return jsonify(specialties)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати лікарів за спеціальністю
@app.route('/api/doctors', methods=['GET'])
def get_doctors():
    specialty_id = request.args.get('specialty_id')
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        if specialty_id:
            query = """
                SELECT s.*, sp.name as specialty_name
                FROM staff s
                JOIN specialties sp ON s.specialty_id = sp.id
                WHERE s.specialty_id = %s AND s.active = 1
                ORDER BY s.last_name, s.first_name
            """
            cursor.execute(query, (specialty_id,))
        else:
            query = """
                SELECT s.*, sp.name as specialty_name
                FROM staff s
                JOIN specialties sp ON s.specialty_id = sp.id
                WHERE s.active = 1
                ORDER BY s.last_name, s.first_name
            """
            cursor.execute(query)
        
        doctors = cursor.fetchall()
        for doctor in doctors:
            if doctor['birth_date']:
                doctor['birth_date'] = doctor['birth_date'].isoformat()
        
        return jsonify(doctors)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Створити візит
@app.route('/api/visits', methods=['POST'])
@role_required('registrar')
def create_visit():
    data = request.json
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO visits (patient_id, doctor_id, scheduled_start, scheduled_end, reason, status)
            VALUES (%s, %s, %s, %s, %s, 'scheduled')
        """
        cursor.execute(query, (
            data['patient_id'],
            data['doctor_id'],
            data['scheduled_start'],
            data.get('scheduled_end'),
            data.get('reason')
        ))
        conn.commit()
        return jsonify({'success': True, 'id': cursor.lastrowid})
    except Error as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Лікарська панель
@app.route('/doctor/<int:doctor_id>')
@login_required
def doctor(doctor_id):
    # Перевірити, чи лікар намагається зайти в свій кабінет
    if session.get('role') == 'doctor' and session.get('staff_id') != doctor_id:
        return redirect(url_for('doctor', doctor_id=session.get('staff_id')))
    
    validate_visits()
    return render_template('doctor.html', doctor_id=doctor_id)

# Отримати всіх лікарів для вибору
@app.route('/api/doctors/all', methods=['GET'])
def get_all_doctors():
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT s.id, s.first_name, s.last_name, s.middle_name, sp.name as specialty_name, s.specialty_id
            FROM staff s
            JOIN specialties sp ON s.specialty_id = sp.id
            WHERE s.active = 1
            ORDER BY s.last_name, s.first_name
        """
        cursor.execute(query)
        doctors = cursor.fetchall()
        return jsonify(doctors)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати пацієнтів з деклараціями для лікаря
@app.route('/api/doctors/<int:doctor_id>/declarations', methods=['GET'])
def get_doctor_declarations(doctor_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT p.*, 
                   d.signed_at,
                   d.active as declaration_active
            FROM declarations d
            JOIN patients p ON d.patient_id = p.id
            WHERE d.doctor_id = %s 
            AND d.active = 1
            AND p.active = 1
            ORDER BY p.last_name, p.first_name
        """
        cursor.execute(query, (doctor_id,))
        patients = cursor.fetchall()
        
        for patient in patients:
            if patient['birth_date']:
                patient['birth_date'] = patient['birth_date'].isoformat()
            if patient['signed_at']:
                patient['signed_at'] = patient['signed_at'].isoformat()
            if patient['created_at']:
                patient['created_at'] = patient['created_at'].isoformat()
        
        return jsonify(patients)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати візити лікаря з фільтрами
@app.route('/api/visits/doctor/<int:doctor_id>', methods=['GET'])
@login_required
def get_doctor_visits(doctor_id):
    # Перевірити, чи лікар намагається отримати свої візити
    if session.get('role') == 'doctor' and session.get('staff_id') != doctor_id:
        return jsonify({'error': 'Доступ заборонено'}), 403
    filter_type = request.args.get('filter', 'today')  
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
    
        base_query = """
            SELECT v.*, 
                   p.first_name as patient_first_name,
                   p.last_name as patient_last_name,
                   p.middle_name as patient_middle_name,
                   p.birth_date as patient_birth_date
            FROM visits v
            JOIN patients p ON v.patient_id = p.id
            WHERE v.doctor_id = %s
        """
        
        if filter_type == 'today':
            query = base_query + " AND DATE(v.scheduled_start) = CURDATE() AND v.status IN ('scheduled', 'done', 'pending_closure')"
            order_by = " ORDER BY v.scheduled_start"
        elif filter_type == 'past':
            query = base_query + " AND (DATE(v.scheduled_start) < CURDATE() OR (DATE(v.scheduled_start) = CURDATE() AND v.status IN ('done', 'pending_closure')))"
            order_by = " ORDER BY v.scheduled_start DESC"
        elif filter_type == 'future':
            query = base_query + " AND (DATE(v.scheduled_start) > CURDATE() OR (DATE(v.scheduled_start) = CURDATE() AND v.status = 'scheduled'))"
            order_by = " ORDER BY v.scheduled_start"
        else:  # всі
            query = base_query
            order_by = " ORDER BY v.scheduled_start DESC"
        
        query = query + order_by
        cursor.execute(query, (doctor_id,))
        visits = cursor.fetchall()
        
        for visit in visits:
            if visit['scheduled_start']:
                visit['scheduled_start'] = visit['scheduled_start'].isoformat()
            if visit['scheduled_end']:
                visit['scheduled_end'] = visit['scheduled_end'].isoformat()
            if visit['patient_birth_date']:
                visit['patient_birth_date'] = visit['patient_birth_date'].isoformat()
            if visit['created_at']:
                visit['created_at'] = visit['created_at'].isoformat()
        
        return jsonify(visits)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати історію діагнозів пацієнта
@app.route('/api/patients/<int:patient_id>/diagnoses', methods=['GET'])
def get_patient_diagnoses(patient_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT d.*, 
                   v.scheduled_start,
                   v.status as visit_status,
                   s.first_name as doctor_first_name,
                   s.last_name as doctor_last_name,
                   s.middle_name as doctor_middle_name,
                   sp.name as specialty_name
            FROM diagnoses d
            JOIN visits v ON d.visit_id = v.id
            JOIN staff s ON v.doctor_id = s.id
            JOIN specialties sp ON s.specialty_id = sp.id
            WHERE d.patient_id = %s
            ORDER BY d.recorded_at DESC
        """
        cursor.execute(query, (patient_id,))
        diagnoses = cursor.fetchall()
        
        for diag in diagnoses:
            if diag['scheduled_start']:
                diag['scheduled_start'] = diag['scheduled_start'].isoformat()
            if diag['recorded_at']:
                diag['recorded_at'] = diag['recorded_at'].isoformat()
        
        return jsonify(diagnoses)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Завершити візит та додати діагноз
@app.route('/api/visits/<int:visit_id>/complete', methods=['POST'])
@login_required
def complete_visit(visit_id):
    # Перевірити, чи лікар намагається завершити свій візит
    if session.get('role') == 'doctor':
        conn = get_db_connection()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("SELECT doctor_id FROM visits WHERE id = %s", (visit_id,))
                result = cursor.fetchone()
                if result and result[0] != session.get('staff_id'):
                    return jsonify({'error': 'Доступ заборонено'}), 403
            finally:
                cursor.close()
                conn.close()
    data = request.json
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()

        conn.start_transaction()
        
        update_visit_query = """
            UPDATE visits 
            SET status = 'done', 
                scheduled_end = NOW(),
                notes = %s
            WHERE id = %s
        """
        cursor.execute(update_visit_query, (data.get('notes'), visit_id))
        
        cursor.execute("SELECT patient_id FROM visits WHERE id = %s", (visit_id,))
        visit_data = cursor.fetchone()
        patient_id = visit_data[0]
        
        # Додати діагноз
        if data.get('diagnosis'):
            insert_diag_query = """
                INSERT INTO diagnoses (visit_id, patient_id, description, primary_diag)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(insert_diag_query, (
                visit_id,
                patient_id,
                data['diagnosis'],
                data.get('primary_diag', True)
            ))
        
        conn.commit()
        return jsonify({'success': True})
    except Error as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Сторінка головного лікаря
@app.route('/chief-doctor')
@role_required('chief')
def chief_doctor():
    validate_visits()
    return render_template('chief_doctor.html')

# Отримати статистику
@app.route('/api/statistics/kpi', methods=['GET'])
@role_required('chief')
def get_kpi_statistics():
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        
        # Всього пацієнтів
        cursor.execute("SELECT COUNT(*) as total FROM patients WHERE active = 1")
        total_patients = cursor.fetchone()['total']
        
        # Візити за поточний місяць
        cursor.execute("""
            SELECT COUNT(*) as total 
            FROM visits 
            WHERE MONTH(scheduled_start) = MONTH(CURDATE()) 
            AND YEAR(scheduled_start) = YEAR(CURDATE())
        """)
        visits_this_month = cursor.fetchone()['total']
        
        # Всього лікарів
        cursor.execute("SELECT COUNT(*) as total FROM staff WHERE active = 1")
        total_doctors = cursor.fetchone()['total']
        
        return jsonify({
            'total_patients': total_patients,
            'visits_this_month': visits_this_month,
            'total_doctors': total_doctors
        })
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати топ лікарів за візитами
@app.route('/api/statistics/top-doctors', methods=['GET'])
@role_required('chief')
def get_top_doctors():
    limit = request.args.get('limit', 5, type=int)
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT 
                s.id,
                s.first_name,
                s.last_name,
                s.middle_name,
                sp.name as specialty_name,
                COUNT(v.id) as visit_count
            FROM staff s
            JOIN specialties sp ON s.specialty_id = sp.id
            LEFT JOIN visits v ON s.id = v.doctor_id AND v.status = 'done'
            WHERE s.active = 1
            GROUP BY s.id, s.first_name, s.last_name, s.middle_name, sp.name
            ORDER BY visit_count DESC
            LIMIT %s
        """
        cursor.execute(query, (limit,))
        doctors = cursor.fetchall()
        return jsonify(doctors)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Отримати топ діагнозів
@app.route('/api/statistics/top-diagnoses', methods=['GET'])
@role_required('chief')
def get_top_diagnoses():
    limit = request.args.get('limit', 10, type=int)
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        
        # Отримати загальну кількість для розрахунку відсотків
        cursor.execute("SELECT COUNT(*) as total FROM diagnoses")
        total_diagnoses = cursor.fetchone()['total']
        
        query = """
            SELECT 
                description,
                COUNT(*) as count
            FROM diagnoses
            WHERE primary_diag = 1
            GROUP BY description
            ORDER BY count DESC
            LIMIT %s
        """
        cursor.execute(query, (limit,))
        diagnoses = cursor.fetchall()
        
        # Розрахувати відсоток
        for diag in diagnoses:
            diag['percentage'] = round((diag['count'] / total_diagnoses * 100), 1) if total_diagnoses > 0 else 0
        
        return jsonify(diagnoses)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/api/visits/<int:visit_id>/cancel', methods=['POST'])
@login_required
def cancel_visit(visit_id):
    if session.get('role') != 'doctor':
        return jsonify({'error': 'У вас немає прав скасовувати візити. Зверніться до лікаря.'}), 403

    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()
    
        cursor.execute("SELECT doctor_id FROM visits WHERE id = %s", (visit_id,))
        result = cursor.fetchone()
    
        if not result:
             return jsonify({'error': 'Візит не знайдено'}), 404

        if result[0] != session.get('staff_id'):
            return jsonify({'error': 'Ви не можете скасувати чужий візит'}), 403

        cursor.execute("UPDATE visits SET status = 'cancelled' WHERE id = %s", (visit_id,))
        conn.commit()
        return jsonify({'success': True})

    except Error as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    # Виконати валідацію візитів при старті додатку (force=True для обов'язкового виконання)
    print("Запуск валідації візитів...")
    validate_visits(force=True)
    app.run(debug=True, port=5000)

