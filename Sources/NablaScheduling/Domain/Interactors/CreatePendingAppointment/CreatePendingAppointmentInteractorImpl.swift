import Foundation

final class CreatePendingAppointmentInteractorImpl: CreatePendingAppointmentInteractor {
    // MARK: - Internal
    
    /// - Throws: ``NablaError``
    func execute(location: LocationType, categoryId: UUID, providerId: UUID, date: Date) async throws -> Appointment {
        try await repository.createPendingAppointment(
            location: location,
            categoryId: categoryId,
            providerId: providerId,
            date: date
        )
    }
    
    // MARK: Init
    
    init(
        repository: AppointmentRepository
    ) {
        self.repository = repository
    }
    
    // MARK: - Private
    
    private let repository: AppointmentRepository
}