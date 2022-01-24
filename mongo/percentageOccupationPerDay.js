db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: "$ScheduleDate",
            percentage: {
                $sum: { $multiply: [{ $divide: [1, 50] }, 100]}
            }
        }
    },
    {$out: "PercentageOccupationPerDay"}
])