import os
import requests
from bs4 import BeautifulSoup
from pymongo import MongoClient
from dotenv import load_dotenv

url = "http://localhost:8984/list"
req = requests.get(url)
soup = BeautifulSoup(req.content, "xml")


def upload_to_mongo():
    load_dotenv()
    uri = os.getenv("MONGODB_URI")
    client = MongoClient(uri)
    print(client)


upload_to_mongo()


def extract_xml(xml):
    output = []

    bookings = xml.Bookings.findAll('Booking')
    for booking in bookings:
        _booking = {
            "Id": int(booking.Id.string),
            "Canceled": bool(booking.Canceled.string),
            "NumberOfMembers": int(booking.NumberOfMembers.string),
            "ScheduleDate": booking.ScheduleDate.string,
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
