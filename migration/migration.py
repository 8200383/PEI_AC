import os
import requests
from datetime import datetime
from bs4 import BeautifulSoup
from pymongo import MongoClient
from dotenv import load_dotenv
from bson.json_util import dumps


def upload_to_mongo(json_document):
    load_dotenv()
    uri = os.getenv("MONGODB_URI")

    client = MongoClient(uri)
    return client.SantaDB.Bookings


def export_to_json(mongo_collection):
    cursor = mongo_collection.find({})
    with open('collection.json', 'w') as file:
        file.write('[')
        for document in cursor:
            file.write(dumps(document))
            file.write(',')
        file.write(']')


def query_basex_for_bookings():
    url = "http://localhost:8984/list"
    req = requests.get(url)
    return BeautifulSoup(req.content, "xml")


def convert_string_to_datetime(date_str):
    return datetime.strptime(date_str, "%Y-%m-%d")


def xml_to_json(xml_document):
    output = []

    bookings = xml_document.Bookings.findAll('Booking')
    for booking in bookings:
        _booking = {
            "Id": int(booking.Id.string),
            "Canceled": bool(booking.Canceled.string),
            "NumberOfMembers": int(booking.NumberOfMembers.string),
            "ScheduleDate": convert_string_to_datetime(booking.ScheduleDate.string),
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
                "Birthday": convert_string_to_datetime(member.Birthday.string)
            }
            _booking["Members"].append(_member)

        output.append(_booking)

    return output


if __name__ == '__main__':
    xml = query_basex_for_bookings()
    json = xml_to_json(xml)
    collection = upload_to_mongo(json)
    collection.delete_many({})
    collection.insert_many(json)
    export_to_json(collection)
