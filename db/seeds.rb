product1 = Product.create({ name: 'Campera Azul (talle XL)', reference: 'CATXL' })
product2 = Product.create({ name: 'Coca-Cola en botella de 2 litros', reference: 'CCB2L' })

storage1 = Storage.create({ name: 'storage1' })
storage2 = Storage.create({ name: 'storage2' })

Stock.create(product: product1, storage: storage1, quantity: 5)
Stock.create(product: product1, storage: storage2, quantity: 10)
Stock.create(product: product2, storage: storage1, quantity: 15)
Stock.create(product: product2, storage: storage2, quantity: 20)
