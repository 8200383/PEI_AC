db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
  {
    $match: {"ScheduleDate": {$lte: new ISODate()}}
  },
  {
    $group: {
      _id: null,
      "Agendamentos": {$sum: 1}
    }
  },
  {
    $project: {"Agendamento até à data de hoje": "$Agendamentos", "_id": 0}
  }
])