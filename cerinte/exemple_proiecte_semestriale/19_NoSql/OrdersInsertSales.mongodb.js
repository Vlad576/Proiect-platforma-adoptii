use('sales');

const customers = db.getCollection('customers').find().limit(3).toArray();
const products = [
  { productId: "PROD001", name: "Laptop", price: 1200.00 },
  { productId: "PROD002", name: "Mouse", price: 25.50 },
  { productId: "PROD003", name: "Keyboard", price: 75.00 },
  { productId: "PROD004", name: "Monitor", price: 300.00 },
  { productId: "PROD005", name: "Webcam", price: 50.75 },
];

let ordersInsertedCount = 0;

customers.forEach(customer => {
  for (let i = 0; i < 2; i++) {
    const numberOfProducts = Math.floor(Math.random() * 2) + 2; 
    const orderProducts = [];
    const selectedProductIndices = new Set();

    while (orderProducts.length < numberOfProducts) {
      const randomIndex = Math.floor(Math.random() * products.length);
      if (!selectedProductIndices.has(randomIndex)) {
        selectedProductIndices.add(randomIndex);
        const product = products[randomIndex];
        orderProducts.push({
          productId: product.productId,
          name: product.name,
          price: product.price,
          quantity: Math.floor(Math.random() * 3) + 1 
        });
      }
    }

    const totalAmount = orderProducts.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const orderDate = new Date();

    const orderToInsert = {
      customerId: customer._id, 
      orderNumber: `ORD-${customer.customerId}-${Math.random().toString(36).substring(7).toUpperCase()}`,
      orderDate: orderDate,
      products: orderProducts,
      totalAmount: totalAmount,
      shippingAddress: customer.address, 
      status: "Processing"
    };

    db.getCollection('orders').insertOne(orderToInsert);

    console.log(`Generated and inserted: ${JSON.stringify(orderToInsert, null, 2)}`);
    ordersInsertedCount++;
  }
});

console.log(`Generated and inserted ${ordersInsertedCount} orders.`);

