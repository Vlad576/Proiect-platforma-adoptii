use("adapost_animale");

// sa se afiseze cainii aflati in tratament
db.animal.find({
    specie: "caine",
    in_tratament: true
});

// sa se afiseze primele cele mai mici 3 custi
db.cusca.find()
.sort({ capacitate: 1 })
.limit(3);
