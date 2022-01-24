db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: {ScheduleDate: "$ScheduleDate"},
            average: {$avg: "$NumberOfMembers"}
        }
    },
    {
        $project: {
            _id: 0,
            ScheduleDate: "$_id.ScheduleDate",
            AverageOfPersons: "$average"
        }
    },
    {$out: "AveragePersonsPerDay"}
])