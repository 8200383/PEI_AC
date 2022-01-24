db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: {"ScheduleDate": "$ScheduleDate"},
            familiesPerDay: {$sum: 1}
        }
    },
    {
        $project: {
            TotalFamiliesPerDay: "$familiesPerDay",
            ScheduleDate: "$_id.ScheduleDate",
            _id: 0
        }
    },
    {$out: "TotalFamaliesPerDay"}
])