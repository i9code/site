typedef ModelBaseBuilder = ModelBase Function(Map json);

abstract class ModelBase {
  static ModelBase fromJson(Map json) {
    return null;
  }
}
