
class ArrayUtil {
  static Function(dynamic, dynamic) sorter(int sortOrder, String property) {
    int handleSortOrder(int sortOrder, int sort) {
      if (sortOrder == 1) {
        // a is before b
        if (sort == -1) {
          return -1;
        } else if (sort > 0) {
          // a is after b
          return 1;
        } else {
          // a is same as b
          return 0;
        }
      } else {
        // a is before b
        if (sort == -1) {
          return 1;
        } else if (sort > 0) {
          // a is after b
          return 0;
        } else {
          // a is same as b
          return 0;
        }
      }
    }

    return (dynamic a, dynamic b) {
      if (a['$property'] == null || b['$property'] == null ) {
        return 0;
      } else {
        var aV;
        var bV;
        if (a['$property'] == true || a['$property'] == false) {
          aV = a['$property'] ? 1 : 0;
        } else {
          aV = a['$property'];
        }
        if (b['$property'] == true || b['$property'] == false) {
          bV = b['$property'] ? 1 : 0;
        } else {
          bV = b['$property'];
        }
        int sort;
        if (sortOrder == 1) {
          sort = aV.compareTo(bV);
        } else {
          sort = bV.compareTo(aV);
        }
        return sort;
//        sort = aV.compareTo(bV);
//        return handleSortOrder(sortOrder, sort);
      }
    };
  }

  static void sortArray(List listArr,
      {int sortOrder = 0, String property = "createdDate"}) {
//    sortOrder 0 倒序从大到小， 1 顺序从小到大
    if (property != null && property != '') {
      listArr.sort(sorter(sortOrder, property));
    }
  }

  static createHash(List<int> ids) {
//    logger.d(ids);
    var hash = 0;
    for (var i = 0; i < ids.length; i++) {
      hash = (((hash * 0x4F25) & 0x7FFFFFFF) + ids[i]) & 0x7FFFFFFF;
    }
    return hash;
  }

  static fileUrlReplace() {

  }
}