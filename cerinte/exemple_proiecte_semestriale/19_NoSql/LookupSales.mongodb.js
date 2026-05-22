use('sales');

const result1 = db.orders.aggregate( [
  {
    $lookup:
      {
        from: "customers",
        localField: "customerId",
        foreignField: "_id",
        as: "customer_info"
      }
 }
] ).toArray();

console.log(`Orders and customers ${JSON.stringify(result1, null, 2)}`);

const result2 = db.customers.aggregate([
  {
    $match: { isActive: true }
  },
  {
    $lookup: {
      from: "orders",
      localField: "_id",
      foreignField: "customerId",
      as: "customerOrders"
    }
  },
  {
    $project: {
      _id: 1,
      customerId: 1,
      firstName: 1,
      lastName: 1,
      email: 1,
      totalOrders: { $size: "$customerOrders" },
      totalOrderValue: { $sum: "$customerOrders.totalAmount" }
    }
  },
  {
    $sort: { totalOrderValue: -1 } 
  }
]).toArray();

console.log(`Customers and aggregated orders: ${JSON.stringify(result2, null, 2)}`)

const result3 = db.orders.aggregate([
  {
    $unwind: "$products"
  },
  {
    $group: {
      _id: "$products.productId",
      productName: { $first: "$products.name" },
      averageQuantity: { $avg: "$products.quantity" },
      totalOrders: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      productId: "$_id",
      productName: 1,
      averageQuantity: { $round: ["$averageQuantity", 2] }, // Optional: Round to 2 decimal places
      totalOrders: 1 
    }
  },
  {
    $sort: { averageQuantity: -1 } 
  }
]).toArray();;

console.log(`Products and orders: ${JSON.stringify(result3, null, 2)}`)

db.createView( "sales", "orders", 
  [
    {
      $unwind: "$products"
    },
    {
      $group: {
        _id: "$products.productId",
        productName: { $first: "$products.name" },
        averageQuantity: { $avg: "$products.quantity" },
        totalOrders: { $sum: 1 }
      }
    },
    {
      $project: {
        _id: 0,
        productId: "$_id",
        productName: 1,
        averageQuantity: { $round: ["$averageQuantity", 2] }, // Optional: Round to 2 decimal places
        totalOrders: 1 
      }
    },
    {
      $sort: { averageQuantity: -1 } 
    }
  ]
);

