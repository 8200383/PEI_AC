db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: null,
            "Agendamentos": {$sum: 1}
        }
    },
    {
        $addFields: {"Agendamentos por cidade e país": "$Agendamentos"}
    },
    {
        $addFields: {"\"Country\" AND \"City\"": {$and: ["Country", "City"]}}
    },
    {
        $sort: {"\"Country\" AND \"City\"": 1}
    },
    {
        $project: {"Agendamentos por cidade e país": 1, "_id": 0}
    }
])