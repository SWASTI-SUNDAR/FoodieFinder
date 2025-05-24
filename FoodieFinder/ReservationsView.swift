import SwiftUI

struct ReservationsView: View {
    @State private var reservations: [Reservation] = [
        Reservation(
            id: UUID(),
            restaurantName: "Bella Vista Italian",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
            time: "7:30 PM",
            partySize: 4,
            status: .confirmed
        ),
        Reservation(
            id: UUID(),
            restaurantName: "Le Petit Bistro",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            time: "6:00 PM",
            partySize: 2,
            status: .pending
        )
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if reservations.isEmpty {
                    EmptyReservationsView()
                } else {
                    List {
                        ForEach(reservations) { reservation in
                            ReservationCard(reservation: reservation)
                        }
                        .onDelete(perform: deleteReservation)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Bookings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add new reservation
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteReservation(at offsets: IndexSet) {
        reservations.remove(atOffsets: offsets)
    }
}

struct Reservation: Identifiable {
    let id: UUID
    let restaurantName: String
    let date: Date
    let time: String
    let partySize: Int
    let status: ReservationStatus
}

enum ReservationStatus {
    case confirmed, pending, cancelled
    
    var color: Color {
        switch self {
        case .confirmed: return .green
        case .pending: return .orange
        case .cancelled: return .red
        }
    }
    
    var title: String {
        switch self {
        case .confirmed: return "Confirmed"
        case .pending: return "Pending"
        case .cancelled: return "Cancelled"
        }
    }
}

struct ReservationCard: View {
    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reservation.restaurantName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(reservation.partySize) guests")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(reservation.status.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(reservation.status.color.opacity(0.2))
                    .foregroundColor(reservation.status.color)
                    .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.orange)
                Text(reservation.date, style: .date)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "clock")
                    .foregroundColor(.orange)
                Text(reservation.time)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptyReservationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Reservations")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Book a table at your favorite restaurant to see your reservations here")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
