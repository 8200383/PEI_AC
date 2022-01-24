db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    { $unwind: "$Members" },
    {
        $group: {
            _id:  {
                City: "$Members.City",
                Country: "$Members.Country"
            },
            Country: {
                $first: "$Members.Country"
            },
            City: {
                $first: "$Members.City"
            },
            count: {$sum: 1}
        }
    },
    {
        $project: {
            _id: 0,
            Country: 1,
            City: 1,
            Bookings: "$count"
        }
    },
    {$out: "TotalBookingsPerCityAndCountry" }
])