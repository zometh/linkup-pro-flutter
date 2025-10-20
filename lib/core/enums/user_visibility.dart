enum UserVisibility {
  private,
  public,
  friends
}

UserVisibility getVisibility(String visibility){
  switch(visibility){
    case "private":
      return UserVisibility.private;
    case "public":
      return UserVisibility.public;
    default:
      return UserVisibility.friends;
  }
}