import 'package:lost_and_found/core/domain/usecases/usecase.dart';

import 'models/category_dto.dart';

abstract class CategoryDataSource {
  Future<List<CategoryDto>> getCategories(NoParams params);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  CategoryDataSourceImpl();

  @override
  Future<List<CategoryDto>> getCategories(NoParams params) async {
    return const [
      CategoryDto(id: 1, name: "Electronics", description: "Phones, Laptops, Gadgets", icon: 57790),
      CategoryDto(id: 2, name: "Documents", description: "IDs, Passports, Cards", icon: 57747),
      CategoryDto(id: 3, name: "Keys", description: "House, Car, Locker keys", icon: 62426),
      CategoryDto(id: 4, name: "Clothing", description: "Jackets, Hats, Scarves", icon: 58943),
      CategoryDto(id: 5, name: "Bags", description: "Backpacks, Wallets, Purses", icon: 57544),
      CategoryDto(id: 6, name: "Other", description: "Miscellaneous items", icon: 58826),
    ];
  }
}