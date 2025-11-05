
enum PostType { publication, annonce }
PostType getPostType(String value){
  switch(value){
    case "POST":
      return PostType.publication;
    case "ANNOUNCEMENT":
      return PostType.annonce;
    default:
      return PostType.publication;


  }
}