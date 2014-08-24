use admin
db.createUser(
  {
    user: "ADMIN_USER",
    pwd: "ADMIN_PASSWORD",
    roles:
    [
      {
        role: "userAdminAnyDatabase",
        db: "admin"
      }
    ]
  }
)
