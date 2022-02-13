# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.all
Product.create({ code: 'A', has_addon: false, price: 2, volume: 5, volume_price: 9, free_criteria: nil })
Product.create({ code: 'B', has_addon: true, price: 10, volume: 0, volume_price: 0, free_criteria: 1 })
Product.create!({ code: 'C', has_addon: false, price: 1.25, volume: 6, volume_price: 6, free_criteria: nil })
Product.create({ code: 'D', has_addon: false, price: 0.15, volume: 0, volume_price: 0, free_criteria: nil })
Product.create({ code: 'E', has_addon: false, price: 2, volume: 0, volume_price: 0, free_criteria: nil })
FreeProduct.create({ product_id: Product.find_by_code('B').id, free_id: Product.find_by_code('E').id })
