db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: {"ScheduleDate": "$ScheduleDate"},
            membersPerDay: {$sum: "$NumberOfMembers"}
        }
    },
    {
        $project: {
            Members: "$membersPerDay",
            ScheduleDate: "$_id.ScheduleDate",
            _id: 0
        }
    },
    {$out: "TotalPersonsPerDay"}
])