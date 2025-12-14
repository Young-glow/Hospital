let specialties = [];
let doctors = [];

document.addEventListener('DOMContentLoaded', function() {
    loadPatients();
    loadSpecialties();
    
    document.getElementById('searchInput').addEventListener('input', function() {
        loadPatients(this.value);
    });
    
    document.getElementById('newPatientForm').addEventListener('submit', function(e) {
        e.preventDefault();
        createPatient();
    });
    
    document.getElementById('scheduleVisitForm').addEventListener('submit', function(e) {
        e.preventDefault();
        scheduleVisit();
    });
});

async function loadPatients(search = '') {
    try {
        const url = search 
            ? `/api/patients?search=${encodeURIComponent(search)}`
            : '/api/patients';
        
        const response = await fetch(url);
        const patients = await response.json();
        
        const tbody = document.getElementById('patientsTableBody');
        
        if (patients.error) {
            tbody.innerHTML = `<tr><td colspan="7" class="error">${patients.error}</td></tr>`;
            return;
        }
        
        if (patients.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 2rem;">Пацієнтів не знайдено</td></tr>';
            return;
        }
        
        tbody.innerHTML = patients.map(patient => `
            <tr>
                <td>${patient.id}</td>
                <td>${patient.last_name}</td>
                <td>${patient.first_name}</td>
                <td>${patient.middle_name || '-'}</td>
                <td>${patient.birth_date ? new Date(patient.birth_date).toLocaleDateString('uk-UA') : '-'}</td>
                <td>${patient.phone || '-'}</td>
                <td>
                    <button class="action-btn btn-visit" onclick="openScheduleVisitModal(${patient.id})">
                        Записати на візит
                    </button>
                </td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading patients:', error);
        document.getElementById('patientsTableBody').innerHTML = 
            '<tr><td colspan="7" class="error">Помилка завантаження даних</td></tr>';
    }
}

async function loadSpecialties() {
    try {
        const response = await fetch('/api/specialties');
        specialties = await response.json();
        
        const select = document.getElementById('specialtySelect');
        select.innerHTML = '<option value="">Оберіть спеціальність</option>' +
            specialties.map(spec => 
                `<option value="${spec.id}">${spec.name}</option>`
            ).join('');
    } catch (error) {
        console.error('Error loading specialties:', error);
    }
}

async function loadDoctors() {
    const specialtyId = document.getElementById('specialtySelect').value;
    const doctorSelect = document.getElementById('doctorSelect');
    
    if (!specialtyId) {
        doctorSelect.innerHTML = '<option value="">Спочатку оберіть спеціальність</option>';
        return;
    }
    
    try {
        const response = await fetch(`/api/doctors?specialty_id=${specialtyId}`);
        doctors = await response.json();
        
        if (doctors.error) {
            doctorSelect.innerHTML = '<option value="">Помилка завантаження</option>';
            return;
        }
        
        doctorSelect.innerHTML = '<option value="">Оберіть лікаря</option>' +
            doctors.map(doctor => 
                `<option value="${doctor.id}">${doctor.last_name} ${doctor.first_name} ${doctor.middle_name || ''} (${doctor.specialty_name})</option>`
            ).join('');
    } catch (error) {
        console.error('Error loading doctors:', error);
        doctorSelect.innerHTML = '<option value="">Помилка завантаження</option>';
    }
}

function openNewPatientModal() {
    document.getElementById('newPatientModal').style.display = 'block';
    document.getElementById('newPatientForm').reset();
}

function closeNewPatientModal() {
    document.getElementById('newPatientModal').style.display = 'none';
}

async function createPatient() {
    const form = document.getElementById('newPatientForm');
    const formData = new FormData(form);
    const data = Object.fromEntries(formData);
    
    try {
        const response = await fetch('/api/patients', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        
        const result = await response.json();
        
        if (result.error) {
            alert('Помилка: ' + result.error);
            return;
        }
        
        alert('Пацієнта успішно додано!');
        closeNewPatientModal();
        loadPatients();
    } catch (error) {
        console.error('Error creating patient:', error);
        alert('Помилка при створенні пацієнта');
    }
}

function openScheduleVisitModal(patientId) {
    document.getElementById('visitPatientId').value = patientId;
    document.getElementById('scheduleVisitModal').style.display = 'block';
    document.getElementById('scheduleVisitForm').reset();
    document.getElementById('doctorSelect').innerHTML = '<option value="">Спочатку оберіть спеціальність</option>';
}

function closeScheduleVisitModal() {
    document.getElementById('scheduleVisitModal').style.display = 'none';
}

async function scheduleVisit() {
    const form = document.getElementById('scheduleVisitForm');
    const formData = new FormData(form);
    const data = Object.fromEntries(formData);
    
    if (data.scheduled_start) {
        const date = new Date(data.scheduled_start);
        data.scheduled_start = date.toISOString().slice(0, 19).replace('T', ' ');
        
        const endDate = new Date(date.getTime() + 20 * 60000);
        data.scheduled_end = endDate.toISOString().slice(0, 19).replace('T', ' ');
    }
    
    try {
        const response = await fetch('/api/visits', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        
        const result = await response.json();
        
        if (result.error) {
            alert('Помилка: ' + result.error);
            return;
        }
        
        alert('Візит успішно записано!');
        closeScheduleVisitModal();
    } catch (error) {
        console.error('Error scheduling visit:', error);
        alert('Помилка при записі на візит');
    }
}

window.onclick = function(event) {
    const newPatientModal = document.getElementById('newPatientModal');
    const scheduleVisitModal = document.getElementById('scheduleVisitModal');
    
    if (event.target == newPatientModal) {
        closeNewPatientModal();
    }
    if (event.target == scheduleVisitModal) {
        closeScheduleVisitModal();
    }
}

