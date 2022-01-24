db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $addFields: {
            Cancelations: {$sum: 1}
        }
    },
    {
        $match: {
            Canceled: {$eq: true}
        }
    },
    {
        $project: {
            ScheduleDate: 1,
            Cancelations: 1,
            _id: 0
        }
    },
    {$out: "CancelationsPerDay"}
])