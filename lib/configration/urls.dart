final String apiUrl ='https://shop-ce6ab.firebaseio.com/';
final String productUrl = apiUrl+ "/products.json";
final String orderUrl = apiUrl+"/orders.json";
String singleProductUrl(id){
  return apiUrl+"/products/$id.json";
}

