db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: {country: "$Country", city: "$City"},
            count: {$sum: 1}
        }
    },
    {
        $project: {
            _id: 0,
            CountryAndCity: "$_id",
            Bookings: "$count"
        }
    }
])