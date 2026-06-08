use("adapost_animale");

db.cusca.find({});

db.cusca.updateOne(
    {_id: ObjectId('6a25b7e61b8cac933f05e021')},
    {$set: {capacitate: 9}}
);

db.cusca.deleteMany(
  { locatie: "exterior" }
)