use('sales');


db.getCollection('customers').insertMany([
  {
    customerId: "CLT001",
    firstName: "Ana",
    lastName: "Popescu",
    email: "ana.popescu@example.com",
    phone: "+40 723 456 789",
    address: {
      street: "Strada Florilor 10",
      city: "Bucharest",
      country: "Romania",
      postalCode: "012345"
    },
    registrationDate: new Date("2024-11-15T10:30:00Z"),
    lastOrderDate: new Date("2025-04-28T14:00:00Z"),
    totalOrders: 5,
    totalSpent: 255.75,
    preferredPaymentMethod: "Credit Card",
    loyaltyPoints: 120,
    isActive: true,
    notes: "Regular customer, prefera email."
  },
  {
    customerId: "CLT002",
    firstName: "Mihai",
    lastName: "Ionescu",
    email: "mihai.ionescu@sample.com",
    phone: "+40 730 987 654",
    address: {
      street: "Bulevardul Unirii 55",
      city: "Cluj-Napoca",
      country: "Romania",
      postalCode: "400123"
    },
    registrationDate: new Date("2023-08-22T16:45:00Z"),
    lastOrderDate: new Date("2025-05-02T09:15:00Z"),
    totalOrders: 12,
    totalSpent: 890.20,
    preferredPaymentMethod: "Online Transfer",
    loyaltyPoints: 350,
    isActive: true,
    notes: "High-value customer, interesat de produse noi."
  },
  {
    customerId: "CLT003",
    firstName: "Adina",
    lastName: "Vasilescu",
    email: "adina.vasilescu@domain.net",
    phone: "+40 744 123 456",
    address: {
      street: "Calea Victoriei 201",
      city: "Iași",
      country: "Romania",
      postalCode: "700025"
    },
    registrationDate: new Date("2024-03-10T08:00:00Z"),
    lastOrderDate: new Date("2025-01-18T11:30:00Z"),
    totalOrders: 3,
    totalSpent: 78.50,
    preferredPaymentMethod: "Cash on Delivery",
    loyaltyPoints: 30,
    isActive: false,
    notes: "Inactive customer."
  },
  {
    customerId: "CLT004",
    firstName: "Andrei",
    lastName: "Stanescu",
    email: "andrei.stanescu@email.org",
    phone: "+40 755 678 901",
    address: {
      street: "Strada Mihai Eminescu 3",
      city: "Timișoara",
      country: "Romania",
      postalCode: "300006"
    },
    registrationDate: new Date("2025-01-05T14:20:00Z"),
    lastOrderDate: new Date("2025-05-04T16:00:00Z"),
    totalOrders: 7,
    totalSpent: 412.99,
    preferredPaymentMethod: "Credit Card",
    loyaltyPoints: 185,
    isActive: true,
    notes: "New customer, comenzi plasate recent."
  }
]);




