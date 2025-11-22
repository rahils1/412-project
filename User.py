class User:
    def __init__(self, uid: int, username: str, householdid: int, isadmin: bool):
        self.uid: int = uid
        self.username: str = username
        self.housholdid: int = householdid
        self.isadmin: bool = isadmin
