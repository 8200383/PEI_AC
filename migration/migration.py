import os
import requests
from bs4 import BeautifulSoup
from pymongo import MongoClient
from dotenv import load_dotenv
from bson.json_util import dumps


def export_to_json(mongo_collection):
    cursor = mongo_collection.find({})
    with open('collection.json', 'w') as file:
        file.write('[')
        for document in cursor:
            file.write(dumps(document))
            file.write(',')
        file.write(']')


def xml_to_json(xml_document):
    output = []
    bookings = xml_document.Bookings.findAll('Booking')

    for booking in bookings:
        _booking = {
            "Id": booking.Id.string,
            "Canceled": booking.Canceled.string,
            "NumberOfMembers": booking.NumberOfMembers.string,
            "ScheduleDate": booking.ScheduleDate.string,
            "City": booking.Members.Member.City.string,
            "Country": booking.Members.Member.Country.string,
            "Members": []
        }
        members = booking.Members.findAll('Member')
        for member in members:
            _member = {
                "Name": member.Name.string,
                "Country": member.Country.string,
                "City": member.City.string,
                "Birthday": member.Birthday.string
            }
            _booking["Members"].append(_member)

        output.append(_booking)

    return output


def transform(db):
    pipeline = [
        {"$unwind": "$Members"},
        {"$set": {
            "Id": {
                "$toInt": "$Id"
            },
            "Canceled": {
                "$toBool": {
                    "$strcasecmp": ["$Canceled", "false"],
                },
            },
            "NumberOfMembers": {
                "$toInt": "$NumberOfMembers"
            },
            "ScheduleDate": {
                "$toDate": "$ScheduleDate"
            },
            "City": "$Members.City",
            "Country": "$Members.Country",
            "Members.Birthday": {
                "$toDate": "$Members.Birthday"
            }
        }},
        {"$group": {
            "_id": "$_id",
            "Id": {
                "$first": "$Id"
            },
            "Canceled": {
                "$first": "$Canceled"
            },
            "NumberOfMembers": {
                "$first": "$NumberOfMembers"
            },
            "ScheduleDate":  {
                "$first": "$ScheduleDate"
            },
            "City": {
                "$first": "$City"
            },
            "Country": {
                "$first": "$Country"
            },
            "Members": {
                "$push": "$Members"
            }
        }},
        {"$merge": {
            "into": {"db": "SantaDB", "coll": "Bookings"},
            "on": "_id",
            "whenMatched": "replace",
            "whenNotMatched": "insert"
        }}
    ]

    db.aggregate(pipeline)


if __name__ == '__main__':
    url = "http://localhost:8984/list"
    req = requests.get(url)
    soup = BeautifulSoup(req.content, "xml")

    json = xml_to_json(soup)

    load_dotenv()
    uri = os.getenv("MONGODB_URI")

    client = MongoClient(uri)
    collection = client.SantaDB.Bookings

    collection.delete_many({})
    collection.insert_many(json)
    transform(collection)
    export_to_json(collection)
