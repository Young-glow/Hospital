document.addEventListener('DOMContentLoaded', function() {
    loadKPI();
    loadTopDoctors();
    loadTopDiagnoses();
});

async function loadKPI() {
    try {
        const response = await fetch('/api/statistics/kpi');
        const data = await response.json();
        
        if (data.error) {
            console.error('Error loading KPI:', data.error);
            return;
        }
        
        document.getElementById('totalPatients').textContent = data.total_patients;
        document.getElementById('visitsThisMonth').textContent = data.visits_this_month;
        document.getElementById('totalDoctors').textContent = data.total_doctors;
    } catch (error) {
        console.error('Error loading KPI:', error);
    }
}

async function loadTopDoctors() {
    try {
        const response = await fetch('/api/statistics/top-doctors?limit=5');
        const doctors = await response.json();
        
        if (doctors.error) {
            document.getElementById('topDoctorsTableBody').innerHTML = 
                '<tr><td colspan="4" class="error">Помилка завантаження</td></tr>';
            return;
        }
        
        if (doctors.length === 0) {
            document.getElementById('topDoctorsTableBody').innerHTML = 
                '<tr><td colspan="4" style="text-align: center; padding: 2rem;">Дані відсутні</td></tr>';
            return;
        }
        
        const tbody = document.getElementById('topDoctorsTableBody');
        tbody.innerHTML = doctors.map((doctor, index) => `
            <tr>
                <td><strong>${index + 1}</strong></td>
                <td>${doctor.last_name} ${doctor.first_name} ${doctor.middle_name || ''}</td>
                <td>${doctor.specialty_name}</td>
                <td><strong>${doctor.visit_count}</strong></td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading top doctors:', error);
        document.getElementById('topDoctorsTableBody').innerHTML = 
            '<tr><td colspan="4" class="error">Помилка завантаження</td></tr>';
    }
}

async function loadTopDiagnoses() {
    try {
        const response = await fetch('/api/statistics/top-diagnoses?limit=10');
        const diagnoses = await response.json();
        
        if (diagnoses.error) {
            document.getElementById('topDiagnosesTableBody').innerHTML = 
                '<tr><td colspan="3" class="error">Помилка завантаження</td></tr>';
            return;
        }
        
        if (diagnoses.length === 0) {
            document.getElementById('topDiagnosesTableBody').innerHTML = 
                '<tr><td colspan="3" style="text-align: center; padding: 2rem;">Дані відсутні</td></tr>';
            return;
        }
        
        const tbody = document.getElementById('topDiagnosesTableBody');
        tbody.innerHTML = diagnoses.map(diag => `
            <tr>
                <td>${diag.description}</td>
                <td><strong>${diag.count}</strong></td>
                <td><strong>${diag.percentage}%</strong></td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading top diagnoses:', error);
        document.getElementById('topDiagnosesTableBody').innerHTML = 
            '<tr><td colspan="3" class="error">Помилка завантаження</td></tr>';
    }
}

