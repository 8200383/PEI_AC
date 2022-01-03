db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
  {
    $group: {
      _id: {"ScheduleDate": "$ScheduleDate"},
      "TotalFamiliesPerDay": {$sum: 1}
    }
  },
  {
    $project: {"TotalFamiliesPerDay": "$TotalFamiliesPerDay", "ScheduleDate": "$_id.ScheduleDate", "_id": 0}
  }
])