from typing import Dict


class User:
    def __init__(self, *, uid: int, username: str, householdid: int, isadmin: bool):
        self.uid: int = uid
        self.username: str = username
        self.householdid: int = householdid
        self.isadmin: bool = isadmin

    def get_dict(self) -> Dict:
        return {
            "uid": self.uid,
            "username": self.username,
            "householdid": self.householdid,
            "isadmin": self.isadmin,
        }
