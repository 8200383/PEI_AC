db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
  {
    $group: {
      _id: {"ScheduleDate": "$ScheduleDate"},
      average: {$avg: "$NumberOfMembers"}
    }
  },
  {
    $project: {
        ScheduleDate: "$_id.ScheduleDate",
        AvgNumberOfMembers: "$average",
        _id: 0
    }
  }
])