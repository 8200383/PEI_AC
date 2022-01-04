db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $match: {"ScheduleDate": {$lte: new ISODate()}}
    },
    {
        $group: {
            _id: null,
            bookings: {$sum: 1}
        }
    },
    {
        $project: {"BookingsUntilTotal": "bookings", "_id": 0}
    }
])