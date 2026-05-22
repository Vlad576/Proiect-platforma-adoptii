use('sales');

const customer1 = db.getCollection('customers').findOne({ customerId: "CLT001" });

if (customer1) {
  db.getCollection('orders').updateMany(
    { customerId: customer1._id },
    {
      $set: {
        discountPercentage: 0.001,
        status: "Confirmed"
      }
    }
  );
  
  console.log(`Successfully updated orders for customer with customerId CLT001.`);
 
}


const customer2 = db.getCollection('customers').findOne({ customerId: "CLT002" });

if (customer2) {
      const orderToUpdate = db.getCollection('orders').findOne({ customerId: customer2._id });

      console.log(`Order to update ${orderToUpdate._id}`);

      if (orderToUpdate) {
        const newProduct = {
          productId: "PROD006",
          name: "Gaming Headset",
          price: 99.99,
          quantity: 1
        };

        const existingProductIdToUpdate = "PROD002"; 
        const newPriceForExistingProduct = 28.00;

        const updateResult1 = db.getCollection('orders').updateOne(
          { _id: orderToUpdate._id }, 
          {
            $push: { "products": newProduct }
          }
        );

        console.log(`Products and orders: ${JSON.stringify(updateResult1, null, 2)}`)

        const updateResult2 = db.getCollection('orders').updateOne(
          { _id: orderToUpdate._id }, 
          {
            $set: { "products.$[elem].price": newPriceForExistingProduct }
          },
          {
            arrayFilters: [ { "elem.productId": existingProductIdToUpdate } ] 
          }
        );

        console.log(`Products and orders: ${JSON.stringify(updateResult2, null, 2)}`)
    }

};

console.log(`Successfully updated orders for customer with customerId CLT002.`);
