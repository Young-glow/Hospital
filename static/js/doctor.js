let currentDoctorId = null;
let currentVisitId = null;
let currentFilter = 'today';
let currentDoctorSpecialtyId = null;

document.addEventListener('DOMContentLoaded', function() {
    const doctorIdElement = document.getElementById('currentDoctorId');
    if (doctorIdElement) {
        currentDoctorId = parseInt(doctorIdElement.value);
        loadDoctorInfo();
    }
    
    document.getElementById('completeVisitForm').addEventListener('submit', function(e) {
        e.preventDefault();
        completeVisit();
    });
});

async function loadDoctorInfo() {
    if (!currentDoctorId) return;
    
    try {
        const response = await fetch('/api/doctors/all');
        const doctors = await response.json();
        const doctor = doctors.find(d => d.id == currentDoctorId);
        
        if (doctor) {
            document.getElementById('doctorName').textContent = 
                `${doctor.last_name} ${doctor.first_name} ${doctor.middle_name || ''}`;
            document.getElementById('doctorSpecialty').textContent = doctor.specialty_name;
            currentDoctorSpecialtyId = doctor.specialty_id;
            
            if (currentDoctorSpecialtyId === 16) {
                document.getElementById('declarationsBlock').style.display = 'block';
                loadDeclarations();
            } else {
                document.getElementById('declarationsBlock').style.display = 'none';
            }
        }
        
        document.getElementById('doctorDashboard').style.display = 'block';
        currentFilter = 'today';
        updateFilterButtons();
        loadVisits('today');
    } catch (error) {
        console.error('Помилка завантаження інформації про лікаря:', error);
    }
}


async function loadDeclarations() {
    if (!currentDoctorId) return;
    
    try {
        const response = await fetch(`/api/doctors/${currentDoctorId}/declarations`);
        const patients = await response.json();
        
        if (patients.error) {
            document.getElementById('declarationsTableBody').innerHTML = 
                '<tr><td colspan="6" class="error">Помилка завантаження</td></tr>';
            return;
        }
        
        if (patients.length === 0) {
            document.getElementById('declarationsTableBody').innerHTML = 
                '<tr><td colspan="6" style="text-align: center; padding: 2rem; color: #666;">Пацієнтів з деклараціями немає</td></tr>';
            return;
        }
        
        const tbody = document.getElementById('declarationsTableBody');
        tbody.innerHTML = patients.map(patient => {
            const birthDate = patient.birth_date ? 
                new Date(patient.birth_date).toLocaleDateString('uk-UA') : '-';
            const signedDate = patient.signed_at ? 
                new Date(patient.signed_at).toLocaleDateString('uk-UA') : '-';
            
            return `
                <tr>
                    <td>${patient.last_name}</td>
                    <td>${patient.first_name}</td>
                    <td>${patient.middle_name || '-'}</td>
                    <td>${birthDate}</td>
                    <td>${patient.phone || '-'}</td>
                    <td>${signedDate}</td>
                </tr>
            `;
        }).join('');
    } catch (error) {
        console.error('Error loading declarations:', error);
        document.getElementById('declarationsTableBody').innerHTML = 
            '<tr><td colspan="6" class="error">Помилка завантаження</td></tr>';
    }
}

function updateFilterButtons() {
    const filters = ['today', 'future', 'past', 'all'];
    filters.forEach(filter => {
        const btn = document.getElementById(`filter${filter.charAt(0).toUpperCase() + filter.slice(1)}`);
        if (btn) {
            if (filter === currentFilter) {
                btn.className = 'btn btn-primary';
            } else {
                btn.className = 'btn btn-secondary';
            }
        }
    });
}

async function loadVisits(filter = 'today') {
    if (!currentDoctorId) return;
    
    currentFilter = filter;
    updateFilterButtons();
    
    try {
        const response = await fetch(`/api/visits/doctor/${currentDoctorId}?filter=${filter}`);
        const visits = await response.json();
        
        if (visits.error) {
            document.getElementById('visitsContainer').innerHTML = 
                '<div class="error">Помилка завантаження візитів</div>';
            return;
        }
        
        if (visits.length === 0) {
            const filterTexts = {
                'today': 'На сьогодні візитів немає',
                'future': 'Майбутніх візитів немає',
                'past': 'Минулих візитів немає',
                'all': 'Візитів немає'
            };
            document.getElementById('visitsContainer').innerHTML = 
                `<div style="text-align: center; padding: 2rem; color: #666;">${filterTexts[filter] || 'Візитів немає'}</div>`;
            return;
        }
        
        const container = document.getElementById('visitsContainer');
        container.innerHTML = visits.map(visit => {
            const date = new Date(visit.scheduled_start);
            const time = date.toLocaleTimeString('uk-UA', { hour: '2-digit', minute: '2-digit' });
            const dateStr = date.toLocaleDateString('uk-UA', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            const statusClass = visit.status === 'done' ? 'status-done' : 
                               visit.status === 'cancelled' ? 'status-cancelled' : 
                               visit.status === 'no-show' ? 'status-no-show' : 
                               visit.status === 'pending_closure' ? 'status-pending-closure' : 'status-scheduled';
            const statusTexts = {
                'done': 'Завершено',
                'scheduled': 'Заплановано',
                'cancelled': 'Скасовано',
                'no-show': 'Не з\'явився',
                'pending_closure': 'Очікує закриття'
            };
            const statusText = statusTexts[visit.status] || visit.status;
            
            return `
                <div class="visit-card" onclick="openVisitCard(${visit.id}, ${visit.patient_id})">
                    <div class="visit-header">
                        <div>
                            <div class="visit-time">${time}</div>
                            <div style="font-size: 0.9rem; color: #666; margin-top: 0.3rem;">${dateStr}</div>
                        </div>
                        <div class="visit-status ${statusClass}">${statusText}</div>
                    </div>
                    <div style="margin-top: 1rem;">
                        <strong>${visit.patient_last_name} ${visit.patient_first_name} ${visit.patient_middle_name || ''}</strong>
                    </div>
                    <div style="margin-top: 0.5rem; color: #666;">
                        ${visit.reason || 'Без причини'}
                    </div>
                </div>
            `;
        }).join('');
    } catch (error) {
        console.error('Error loading visits:', error);
        document.getElementById('visitsContainer').innerHTML = 
            '<div class="error">Помилка завантаження візитів</div>';
    }
}

async function openVisitCard(visitId, patientId) {
    currentVisitId = visitId;
    document.getElementById('completeVisitId').value = visitId;
    
    await loadDiagnosisHistory(patientId);
    
    document.getElementById('diagnosisInput').value = '';
    document.getElementById('visitNotes').value = '';
    document.getElementById('primaryDiag').checked = true;
    
    document.getElementById('visitCardModal').style.display = 'block';
}

async function loadDiagnosisHistory(patientId) {
    try {
        const response = await fetch(`/api/patients/${patientId}/diagnoses`);
        const diagnoses = await response.json();
        
        if (diagnoses.error) {
            document.getElementById('diagnosisHistory').innerHTML = 
                '<div class="error">Помилка завантаження історії</div>';
            return;
        }
        
        if (diagnoses.length === 0) {
            document.getElementById('diagnosisHistory').innerHTML = 
                '<div style="text-align: center; padding: 2rem; color: #666;">Історія діагнозів відсутня</div>';
            return;
        }
        
        const history = document.getElementById('diagnosisHistory');
        history.innerHTML = diagnoses.map(diag => {
            const date = new Date(diag.recorded_at);
            const dateStr = date.toLocaleDateString('uk-UA', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
            
            return `
                <div class="diagnosis-item">
                    <h4>${diag.description}</h4>
                    <div class="diagnosis-date">${dateStr}</div>
                    <div class="diagnosis-doctor">Лікар: ${diag.doctor_last_name} ${diag.doctor_first_name} (${diag.specialty_name})</div>
                </div>
            `;
        }).join('');
    } catch (error) {
        console.error('Error loading diagnosis history:', error);
        document.getElementById('diagnosisHistory').innerHTML = 
            '<div class="error">Помилка завантаження історії</div>';
    }
}

async function completeVisit() {
    const visitId = document.getElementById('completeVisitId').value;
    const diagnosis = document.getElementById('diagnosisInput').value;
    const notes = document.getElementById('visitNotes').value;
    const primaryDiag = document.getElementById('primaryDiag').checked;
    
    if (!diagnosis.trim()) {
        alert('Будь ласка, введіть діагноз');
        return;
    }
    
    try {
        const response = await fetch(`/api/visits/${visitId}/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                diagnosis: diagnosis,
                notes: notes,
                primary_diag: primaryDiag
            })
        });
        
        const result = await response.json();
        
        if (result.error) {
            alert('Помилка: ' + result.error);
            return;
        }
        
        alert('Прийом успішно завершено!');
        closeVisitCardModal();
        loadVisits(currentFilter);
    } catch (error) {
        console.error('Error completing visit:', error);
        alert('Помилка при завершенні прийому');
    }
}

function closeVisitCardModal() {
    document.getElementById('visitCardModal').style.display = 'none';
    currentVisitId = null;
}

window.onclick = function(event) {
    const modal = document.getElementById('visitCardModal');
    if (event.target == modal) {
        closeVisitCardModal();
    }
}

