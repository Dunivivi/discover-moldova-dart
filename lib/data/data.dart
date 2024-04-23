import 'package:discounttour/model/country_model.dart';
import 'package:discounttour/model/popular_tours_model.dart';

List<String> getCategories() {
  List<String> categories = [
    "Toate",
    "Aventură",
    "Meșteșug",
    "Gastronomie",
    "Vinării",
    "Copii",
    "Insta",
    "Etno",
    "Istorie",
    "Religie",
    "Artă",
    "Natură",
    "Terapie",
    "Popas",
    "Cazare",
    "Suvenire",
    "Agenţii",
    "Info",
    "Campinguri",
    "Benzinării"
  ];

  return categories;
}


List<CountryModel> getCountrys() {
  List<CountryModel> country = new List();
  CountryModel countryModel = new CountryModel();

//1
  countryModel.countryName = "Orheiul Vechi";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://photos.pandatur.md/e48e1c1fb92ff94d7b0ddb6e04937885.jpg";
  country.add(countryModel);
  countryModel = new CountryModel();

  //2
  countryModel.countryName = "Dendrarium";
  countryModel.label = "New";
  countryModel.noOfTours = 12;
  countryModel.rating = 4.3;
  countryModel.imgUrl =
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/409456790.jpg?k=a3a3ea0e836d5d0d015d4a251f1fedc080ec8976ee0fd064d2ffa3e98a2a9442&o=&hp=1";
  country.add(countryModel);
  countryModel = new CountryModel();

  //3
  countryModel.countryName = "Valea Morilor";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://s.inyourpocket.com/img/figure/2020-02/chisinau_moldova_inyourpocket.jpg";
  country.add(countryModel);
  countryModel = new CountryModel();

  //4
  countryModel.countryName = "Catedrala";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Ansamblul_Catedralei_%E2%80%9ENa%C8%99terea_Domnului%E2%80%9D_8.jpg/1200px-Ansamblul_Catedralei_%E2%80%9ENa%C8%99terea_Domnului%E2%80%9D_8.jpg";
  country.add(countryModel);
  countryModel = new CountryModel();

  //5
  countryModel.countryName = "Muzeul Național de Istorie";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://visit.chisinau.md/wp-content/uploads/2021/09/21-2-1024x679.jpg";
  country.add(countryModel);
  countryModel = new CountryModel();

  //6
  countryModel.countryName = "Asconi";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://asconiwinery.com/wp-content/uploads/2021/03/asconi-winery-home-10-1.jpg";
  country.add(countryModel);
  countryModel = new CountryModel();

  //7
  countryModel.countryName = "Cetatea Bender";
  countryModel.label = "New";
  countryModel.noOfTours = 18;
  countryModel.rating = 4.5;
  countryModel.imgUrl =
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/24/0f/fb/0d/1.jpg?w=1400&h=-1&s=1";
  country.add(countryModel);
  countryModel = new CountryModel();

  return country;
}

List<PopularTourModel> getPopularTours() {
  List<PopularTourModel> popularTourModels = new List();
  PopularTourModel popularTourModel = new PopularTourModel();

//1
  popularTourModel.imgUrl =
      "https://photos.pandatur.md/e48e1c1fb92ff94d7b0ddb6e04937885.jpg";
  popularTourModel.title = "Orheiul Vechi";
  popularTourModel.desc = "1 noapte pentru 2 persoane";
  popularTourModel.price = "\$ 50";
  popularTourModel.rating = 4.5;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//2
  popularTourModel.imgUrl =
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/409456790.jpg?k=a3a3ea0e836d5d0d015d4a251f1fedc080ec8976ee0fd064d2ffa3e98a2a9442&o=&hp=1";
  popularTourModel.title = "Dendrarium";
  popularTourModel.desc = "4 persoane";
  popularTourModel.price = "\$ 5";
  popularTourModel.rating = 4.3;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//3
  popularTourModel.imgUrl =
      "https://asconiwinery.com/wp-content/uploads/2021/03/asconi-winery-home-10-1.jpg";
  popularTourModel.title = "Asconi";
  popularTourModel.desc = "Vinăria ce reprezintă Republica Moldova";
  popularTourModel.price = "\$ 100";
  popularTourModel.rating = 4.5;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//4
  popularTourModel.imgUrl =
      "https://visit.chisinau.md/wp-content/uploads/2021/09/21-2-1024x679.jpg";
  popularTourModel.title = "Muzeul Național de Istorie";
  popularTourModel.desc = "Istoria țării într-un edificiu";
  popularTourModel.price = "\$ 10";
  popularTourModel.rating = 4.5;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//5
  popularTourModel.imgUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Ansamblul_Catedralei_%E2%80%9ENa%C8%99terea_Domnului%E2%80%9D_8.jpg/1200px-Ansamblul_Catedralei_%E2%80%9ENa%C8%99terea_Domnului%E2%80%9D_8.jpg";
  popularTourModel.title = "Catedrala";
  popularTourModel.desc = "Simbolul creștinismului";
  popularTourModel.price = "\$ 0";
  popularTourModel.rating = 4.5;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//6
  popularTourModel.imgUrl =
      "https://s.inyourpocket.com/img/figure/2020-02/chisinau_moldova_inyourpocket.jpg";
  popularTourModel.title = "Valea Morilor";
  popularTourModel.desc = "Parc pentru relaxare";
  popularTourModel.price = "\$ 0";
  popularTourModel.rating = 4.5;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//7
  popularTourModel.imgUrl =
      "https://images.pexels.com/photos/358457/pexels-photo-358457.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  popularTourModel.title = "Thailand";
  popularTourModel.desc = "10 nights for two/all inclusive";
  popularTourModel.price = "\$ 245.50";
  popularTourModel.rating = 4.0;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

//8
  popularTourModel.imgUrl =
      "https://images.pexels.com/photos/358457/pexels-photo-358457.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  popularTourModel.title = "Thailand";
  popularTourModel.desc = "10 nights for two/all inclusive";
  popularTourModel.price = "\$ 245.50";
  popularTourModel.rating = 4.0;
  popularTourModels.add(popularTourModel);
  popularTourModel = new PopularTourModel();

  return popularTourModels;
}
