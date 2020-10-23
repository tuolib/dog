import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../index.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";

//  static final _databaseVersion = 1;
  static final _databaseVersion = 49;
  static final table = 'my_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';
  var chatListTable = 'chat_list_table';
  var groupRoom = 'group_room';
  var groupUser = 'group_user';
  var groupMessage = 'group_message';
  var userTable = 'user_table';
  var contactsTable = 'contacts_table';
  var fileTable = 'file_table';
  var callTable = 'call_table';
  var deviceTable = 'device_table';

//  static final tableChatList = 'tableChatList';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await Git().getSaveDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
//    userTable
    await db.execute('''
          CREATE TABLE $userTable (
            id INTEGER PRIMARY KEY,
            username TEXT,
            avatar INTEGER,
            firstName TEXT,
            lastName TEXT,
            colorId INTEGER,
            lastSeen INTEGER,
            isOnline INTEGER,
            infoTimestamp INTEGER,
            bio  TEXT
          )
          ''');
//    groupRoom
    await db.execute('''
          CREATE TABLE $groupRoom (
            id INTEGER PRIMARY KEY,
            createdUserId INTEGER,
            groupType INTEGER,
            groupName TEXT,
            createdDate INTEGER,
            avatar INTEGER,
            colorId INTEGER,
            infoTimestamp INTEGER,
            userTimestamp INTEGER,
            description TEXT
          )
          ''');
//    groupUser
    await db.execute('''
          CREATE TABLE $groupUser (
            id INTEGER DEFAULT 0,
            groupId INTEGER DEFAULT 0,
            userId INTEGER,
            lastReadMsgId INTEGER DEFAULT 0,
            deleteChat INTEGER DEFAULT 1,
            hasGetOldest INTEGER DEFAULT 0,
            lastDeleteMsgId INTEGER DEFAULT 0,
            lastDeleteMsgTime INTEGER DEFAULT 0,
            oldestMsgId INTEGER DEFAULT 0,
            oldestMsgTime INTEGER DEFAULT 0,
            leaveMessageId INTEGER DEFAULT 0,
            leaveGroupName TEXT,
            inviteUserId INTEGER DEFAULT 0,
            contactId INTEGER DEFAULT 0,
            infoTimestamp INTEGER DEFAULT 0,
            messageId INTEGER DEFAULT 0,
            timestamp INTEGER DEFAULT 0,
            unread INTEGER DEFAULT 0,
            latestMsgId INTEGER DEFAULT 0,
            latestMsgTime INTEGER DEFAULT 0,
            scrollIndex INTEGER DEFAULT 0,
            scrollOffset REAL DEFAULT 0,
            extentBefore REAL DEFAULT 0,
            extentAfter REAL DEFAULT 0,
            extentAfterId INTEGER DEFAULT 0,
            extentBeforeId INTEGER DEFAULT 0,
            pts INTEGER DEFAULT 0
          )
          ''');
//    groupMessage
    await db.execute('''
          CREATE TABLE $groupMessage (
            id INTEGER,
            groupId INTEGER,
            contactId INTEGER,
            senderId INTEGER,
            createdDate INTEGER,
            content TEXT,
            contentType INTEGER,
            contentId INTEGER,
            contentName TEXT,
            isReply INTEGER,
            replyId INTEGER,
            timestamp INTEGER,
            downloading INTEGER
          )
          ''');
//    file table
    await db.execute('''
        CREATE TABLE $fileTable (
          id INTEGER PRIMARY KEY,
          name TEXT,
          fileName TEXT,
          fileSize REAL,
          fileWidth REAL,
          fileHeight REAL,
          fileTime INTEGER,
          fileOriginUrl TEXT,
          fileOriginLocal TEXT,
          fileCompressUrl TEXT,
          fileCompressLocal TEXT,
          timestamp INTEGER
        )
      ''');
//    contacts
    await db.execute('''
           CREATE TABLE $contactsTable (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            contactId INTEGER,
            firstName TEXT,
            lastName TEXT,
            infoTimestamp INTEGER
          )
          ''');
//    chatListTable
    await db.execute('''
          CREATE TABLE $chatListTable (
            groupId INTEGER,
            userId INTEGER,
            contactId INTEGER,
            messageId INTEGER,
            timestamp INTEGER,
            newChatNumber INTEGER DEFAULT 0,
            latestMsgId INTEGER,
            latestMsgTime INTEGER,
            createdDate INTEGER,
            groupUserLength INTEGER,
            groupType INTEGER,
            content TEXT,
            contentName TEXT,
            contentType INTEGER,
            senderId INTEGER
          )
          ''');
//
//    contactId INTEGER,
//
//    groupAvatar TEXT,
//    groupAvatarLocal TEXT,
//    avatarName TEXT,
//    groupName TEXT,
//    username TEXT,
//    isOnline INTEGER,
//    sendName TEXT,
//    colorId INTEGER

//    example table
    await db.execute('''
          CREATE TABLE $table (
            '_id' INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $callTable (
            id TEXT,
            groupId TEXT,
            callerName TEXT,
            uuid TEXT
          )
          ''');
//    await db.execute('''
//      CREATE INDEX index_name ON $groupMessage(createdDate,groupId)
//    ''');
    // await db.execute('CREATE INDEX test_groupId ON $groupMessage(groupId)');
    await db.execute('''
        CREATE TABLE $deviceTable (
          id INTEGER,
          authtoken TEXT,
          userId INTEGER,
          loginType INTEGER,
          deviceInfo TEXT
        )
        ''');
    print("Created tables");
//    update table_name set
//    content_url = replace(content_url, '', '')
//    where
//    content_url like '%%';
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
   // await db.execute("DROP TABLE IF EXISTS $chatListTable");
   //  await db.execute("DROP TABLE IF EXISTS $groupRoom");
   //  await db.execute("DROP TABLE IF EXISTS $groupUser");
   //  await db.execute("DROP TABLE IF EXISTS $groupMessage");
   //  await db.execute("DROP TABLE IF EXISTS $contactsTable");
   //  await db.execute("DROP TABLE IF EXISTS $userTable");
   //  await db.execute("DROP TABLE IF EXISTS $fileTable");
   //  await db.execute("DROP TABLE IF EXISTS $table");
   //  await db.execute("DROP TABLE IF EXISTS $callTable");
   //  await db.execute("DROP TABLE IF EXISTS $deviceTable");
   //  await _onCreate(db, newVersion);
    if (oldVersion < newVersion) {
      // await db.execute("ALTER TABLE $groupRoom ADD COLUMN pts INTEGER DEFAULT 0");
//      await db.execute('CREATE INDEX test_createdDate ON $groupMessage(createdDate)');
//      await db.execute('CREATE INDEX test_groupId ON $groupMessage(groupId)');
//      await db
//          .execute("ALTER TABLE $groupUser ADD COLUMN pts INTEGER DEFAULT 0");
      logger.d('_onUpgrade');
      // await db.execute('''
      //     CREATE TABLE $deviceTable (
      //       id INTEGER,
      //       authtoken TEXT,
      //       userId INTEGER,
      //       loginType INTEGER,
      //       deviceInfo TEXT
      //     )
      //     ''');
    }
  }

  fileUpdateLocalUrl() async {
    /// update fileTable file local path
    /// sandbox
    /// ios app 更新时修改 沙盒路径中的 hash
    if (!Platform.isIOS) {
      return;
    }

    var st = DateTime.now().millisecondsSinceEpoch;
    Database db = await instance.database;
    var stri = await db.rawQuery('''
    SELECT * FROM $fileTable WHERE fileCompressLocal like '%/Application/%'
    LIMIT 1
    ''');
//    logger.d(stri);
    if (stri.length == 0) {
      return;
    }
    var newHash;
    var pathDir = await Git().getSaveDirectory();
    var newHashPath = pathDir.path;

    var n1 = newHashPath.split('/');
    for (var i = 0; i < n1.length; i++) {
      if (n1[i] == 'Application') {
        newHash = n1[i + 1];
        break;
      }
    }

    var oldHash;
    var oldHashPath = stri[0]['fileCompressLocal'];
    var n2 = oldHashPath.split('/');
    for (var i = 0; i < n2.length; i++) {
      if (n2[i] == 'Application') {
        oldHash = n2[i + 1];
        break;
      }
    }


    var end = DateTime.now().millisecondsSinceEpoch;
    logger.d('ios hash get time: ${end - st}');
    if (newHash == oldHash) {
      return;
    }
//    var count;
    try {
      await db.rawUpdate('''
          UPDATE $fileTable 
          SET fileCompressLocal=replace(fileCompressLocal, '$oldHash', '$newHash')
          ''');
      await db.rawUpdate('''
          UPDATE $fileTable 
          SET fileOriginLocal=replace(fileOriginLocal, '$oldHash', '$newHash')
          ''');
    } catch (e) {}

    print('ios hash update time: ${end - st}');
  }

  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

//  chat 列表
  Future<int> chatListInsert(ChatListSql row) async {
    Database db = await instance.database;
    return await db.insert(chatListTable, row.toMap());
  }

  Future<int> chatListUpdateByContactId(ChatListSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db.update(chatListTable, row.toMap(),
          where: "contactId = ?", whereArgs: [row.contactId]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  getChatByContactId(contactId) async {
    Database db = await instance.database;
    var res = await db
        .query(chatListTable, where: "contactId = ?", whereArgs: [contactId]);
    return res.isNotEmpty ? ChatListSql.fromMap(res.first) : null;
  }

  getChat(int groupId) async {
    Database db = await instance.database;
    var res = await db
        .query(chatListTable, where: "groupId = ?", whereArgs: [groupId]);
    return res.isNotEmpty ? ChatListSql.fromMap(res.first) : null;
  }

  getChatListAllRows() async {
//    Database db = await instance.database;
//    return await db.query(chatListTable);
    Database db = await instance.database;
    var res = await db.query(chatListTable);
//    List<ChatListSql> list =
//    res.isNotEmpty ? res.map((c) => ChatListSql.fromMap(c)).toList() : [];
    return res;
  }

  chatListQueryByCondition(String conditionStr) async {
    Database db = await instance.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM $chatListTable WHERE $conditionStr');
    return list.length > 0 ? list : null;
  }

  chatListUpdate(ChatListSql row) async {
//    Database db = await instance.database;
//    int id = row['groupId'];
//    return await db
//        .update(chatListTable, row, where: 'groupId = ?', whereArgs: [id]);
    Database db = await instance.database;
    var res;
    try {
      res = await db.update(chatListTable, row.toMap(),
          where: "groupId = ?", whereArgs: [row.groupId]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  chatListUpdateOrInsert(ChatListSql row) async {
    var index = await getChat(row.groupId);
    var res;
    if (index != null) {
      res = await chatListUpdate(row);
    } else {
      res = await chatListInsert(row);
    }
    return res;
  }

  chatListUpdateList(ChatListSql row) async {
    Database db = await instance.database;
    var index = await getChat(row.groupId);
    var res;
    if (index != null) {
//      chatListUpdate(row);
      res = await db.update(chatListTable, row.toMap(),
          where: "groupId = ?", whereArgs: [row.groupId]);
    } else {
//      await chatListInsert(row);
      var inNum = await db.insert(chatListTable, row.toMap());
    }
//    var res = await db.update(chatListTable, row.toMap(),
//        where: "groupId = ?", whereArgs: [row.groupId]);
//    if (res == null) {
//      await chatListInsert(row);
//    }
    return res;
  }

  chatListUpdateMultiple(String condition, List valueArr, int groupId) async {
    Database db = await instance.database;
// condition : name = ?, value = ? WHERE groupId = ?
    int count =
        await db.rawUpdate('UPDATE $chatListTable SET $condition', valueArr);
    return count;
  }

  chatListUpdateOrInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
//    Database db = await instance.database;
    String cond = '';
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        cond += condition[i] + '= ${conditionValueArr[i]}';
      } else {
        cond += condition[i] + '=${conditionValueArr[i]} AND ';
      }
    }
    var index = await chatListQueryByCondition(cond);

    var res;
    if (index != null) {
      res = await chatListUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await chatListInsertProperty(
          property, condition, propertyValueArr, conditionValueArr);
    }
    return res;
  }

  chatListInsertProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    var propertyAll = [...property, ...condition];
    var conditionAll = [...propertyValueArr, ...conditionValueArr];
    for (var i = 0; i < propertyAll.length; i++) {
      if (i == propertyAll.length - 1) {
        propertyStr += propertyAll[i];
        valuesStr += '?';
      } else {
        propertyStr += propertyAll[i] + ',';
        valuesStr += '?, ';
      }
    }
    var valueArr = conditionAll;

    int count = await db.rawInsert(
        'INSERT INTO  $chatListTable ($propertyStr) VALUES ($valuesStr)',
        valueArr);
    return count;
  }

  chatListUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=? AND ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    int count = await db.rawUpdate(
        'UPDATE $chatListTable SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  Future<int> chatListDelete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(chatListTable, where: 'groupId = ?', whereArgs: [id]);
  }

  deleteAllChatList() async {
    Database db = await instance.database;
    db.rawDelete("Delete * from $chatListTable");
  }

//  Conversation 聊天消息
  getConversationAllRows() async {
    Database db = await instance.database;
    var res = await db.query(groupMessage);
    return res;
  }

// contacts
  contactAll() async {
    Database db = await instance.database;
    var res = await db.query(contactsTable);
    return res;
  }

  contactOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(contactsTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ContactSql.fromMap(res.first) : null;
  }

  contactAdd(ContactSql row) async {
    Database db = await instance.database;
    return await db.insert(contactsTable, row.toMap());
  }

  contactUpdate(ContactSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db.update(contactsTable, row.toMap(),
          where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  contactUpdateOrInsert(ContactSql row) async {
    var index = await contactOne(row.id);
    var res;
    if (index != null) {
      res = await contactUpdate(row);
    } else {
      res = await contactAdd(row);
    }
    return res;
  }

  deleteContacts(int id) async {
    Database db = await instance.database;
    return await db.delete(contactsTable, where: 'id = ?', whereArgs: [id]);
  }

  contactOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(contactsTable,
        where: "$conditionStr", whereArgs: conditionValueArr);
    return res.isNotEmpty ? ContactSql.fromMap(res.first) : null;
  }

  contactMultipleCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(contactsTable,
        where: "$conditionStr", whereArgs: conditionValueArr);
    return res.isNotEmpty ? res : [];
  }

  contactUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=?, ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    int count = await db.rawUpdate(
        'UPDATE $contactsTable SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  contactInsertProperty(List property, List propertyValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
        valuesStr += '?';
      } else {
        propertyStr += property[i] + '=?, ';
        valuesStr += '?, ';
      }
    }
    var valueArr = [...propertyValueArr];
    await db.transaction((txn) async {
      res = await txn.rawInsert(
          'INSERT INTO $contactsTable ($propertyStr) VALUES($valuesStr)',
          valueArr);
    });
    return res;
  }

  contactUpdateOrInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
//    Database db = await instance.database;
    var index = await contactOneCondition(condition, conditionValueArr);
    var res;
    if (index != null) {
      res = await contactUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await contactInsertProperty(property, propertyValueArr);
    }
    return res;
  }

//  user
  userAll() async {
    Database db = await instance.database;
    var res = await db.query(userTable);
    return res;
  }

  userOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(userTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? UserSql.fromMap(res.first) : null;
  }

  userAdd(UserSql row) async {
    Database db = await instance.database;
    return await db.insert(userTable, row.toMap());
  }

  userUpdate(UserSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db
          .update(userTable, row.toMap(), where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  userUpdateOrInsert(UserSql row) async {
    var index = await userOne(row.id);
    var res;
    if (index != null) {
      res = await userUpdate(row);
    } else {
      res = await userAdd(row);
    }
    return res;
  }

  userDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(userTable, where: 'id = ?', whereArgs: [id]);
  }

  userOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(userTable,
        where: "$conditionStr", whereArgs: conditionValueArr);
    return res.isNotEmpty ? UserSql.fromMap(res.first) : null;
  }

  userQueryByString(String conditionStr) async {
//    var strC = '''contactId =${chat['contactId']}
//    AND contactId = ${chat['contactId']}''';
    Database db = await instance.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM $userTable WHERE $conditionStr');
    return list.length > 0 ? list : null;
  }

  userUpdateOrInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
//    Database db = await instance.database;
    String cond = '';
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        cond += condition[i] + '= ${conditionValueArr[i]}';
      } else {
        cond += condition[i] + '=${conditionValueArr[i]} AND ';
      }
    }
    var index = await userQueryByString(cond);
    var res;
    if (index != null) {
      res = await userUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await userInsertProperty(
          property, condition, propertyValueArr, conditionValueArr);
    }
    return res;
  }

  userUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=? AND ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
//    logger.d(valueArr);
    int count = await db.rawUpdate(
        'UPDATE $userTable SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  userInsertProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    var propertyAll = [...property, ...condition];
    var conditionAll = [...propertyValueArr, ...conditionValueArr];
    for (var i = 0; i < propertyAll.length; i++) {
      if (i == propertyAll.length - 1) {
        propertyStr += propertyAll[i];
        valuesStr += '?';
      } else {
        propertyStr += propertyAll[i] + ',';
        valuesStr += '?, ';
      }
    }
    var valueArr = conditionAll;

    int count = await db.rawInsert(
        'INSERT INTO  $userTable ($propertyStr) VALUES ($valuesStr)', valueArr);
    return count;
//    await db.transaction((txn) async {
//      res = await txn.rawInsert(
//          'INSERT INTO $userTable ($propertyStr) VALUES($valuesStr)', valueArr);
//    });
    return res;
  }

  //  groupRoom
  groupRoomAll() async {
    Database db = await instance.database;
    var res = await db.query(groupRoom);
    return res;
  }

  groupRoomOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(groupRoom, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? GroupRoomSql.fromMap(res.first) : null;
  }

  groupRoomAdd(GroupRoomSql row) async {
    Database db = await instance.database;
    return await db.insert(groupRoom, row.toMap());
  }

  groupRoomUpdate(GroupRoomSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db
          .update(groupRoom, row.toMap(), where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  groupRoomUpdateOrInsert(GroupRoomSql row) async {
    var index = await groupRoomOne(row.id);
    var res;
    if (index != null) {
      res = await groupRoomUpdate(row);
    } else {
      res = await groupRoomAdd(row);
    }
    return res;
  }

  groupRoomDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(groupRoom, where: 'id = ?', whereArgs: [id]);
  }

  groupRoomOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(groupRoom,
        where: "$conditionStr", whereArgs: [conditionValueArr]);
    return res.isNotEmpty ? GroupRoomSql.fromMap(res.first) : null;
  }

  groupRoomUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=?, ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    int count = await db.rawUpdate(
        'UPDATE $groupRoom SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  groupRoomInsertProperty(List property, List propertyValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
        valuesStr += '?';
      } else {
        propertyStr += property[i] + '=?, ';
        valuesStr += '?, ';
      }
    }
    var valueArr = [...propertyValueArr];
    await db.transaction((txn) async {
      res = await txn.rawInsert(
          'INSERT INTO $groupRoom ($propertyStr) VALUES($valuesStr)', valueArr);
    });
    return res;
  }

  groupRoomUpdateOrInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
//    Database db = await instance.database;
    var index = await groupRoomOneCondition(condition, conditionValueArr);
    var res;
    if (index != null) {
      res = await groupRoomUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await groupRoomInsertProperty(property, propertyValueArr);
    }
    return res;
  }

  //  groupUser
  groupUserAll() async {
    Database db = await instance.database;
    var res = await db.query(groupUser);
    return res;
  }

  groupUserOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(groupUser, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? GroupUserSql.fromMap(res.first) : null;
  }

  groupUserOneByContactId(int id, int contactId) async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM $groupUser WHERE userId = $id AND contactId = $contactId');
//    var res = await db.query(groupUser, where: "userId = ?, contactId = ?", whereArgs: [id, contactId]);
    return list.isNotEmpty ? list : null;
  }

  groupUserAdd(GroupUserSql row) async {
    Database db = await instance.database;
    return await db.insert(groupUser, row.toMap());
  }

  groupUserUpdate(GroupUserSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db
          .update(groupUser, row.toMap(), where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  groupUserUpdateOrInsert(GroupUserSql row) async {
    var index;

    /// 因为存在 id 为0 的 单人对话（未创建groupId)
    if (row.contactId != 0) {
      var conditionStr = '''
      userId=${row.userId}
      AND contactId=${row.contactId}
      ''';
      index = await groupUserMultipleQuery(conditionStr);
    } else {
      index = await groupUserOne(row.id);
    }
    var res;
    if (index != null) {
      if (row.id != 0) {
//        res = await groupUserUpdate(row);
        if (row.contactId != 0) {
          res = await groupUserUpdateProperty(
            [
              'id',
              'groupId',
              'lastReadMsgId',
              'lastDeleteMsgId',
              'leaveMessageId',
              'infoTimestamp',
              'leaveMessageId',
              'inviteUserId'
            ],
            ['userId', 'contactId'],
            [
              row.id,
              row.groupId,
              row.lastReadMsgId,
              row.lastDeleteMsgId,
              row.leaveMessageId,
              row.infoTimestamp,
              row.leaveMessageId,
              row.inviteUserId,
            ],
            [row.userId, row.contactId],
          );
          await chatListUpdateProperty(
            [
              'groupId',
            ],
            ['userId', 'contactId'],
            [
              row.groupId,
            ],
            [row.userId, row.contactId],
          );
          await groupMessageUpdateProperty(
            [
              'groupId',
            ],
            ['senderId', 'contactId'],
            [
              row.groupId,
            ],
            [row.userId, row.contactId],
          );
        } else {
          res = await groupUserUpdate(row);
        }
      } else {
//
//        id INTEGER,
//            groupId INTEGER,
//    userId INTEGER,
//    lastReadMsgId INTEGER,
//    deleteChat INTEGER,
//    lastDeleteMsgId INTEGER,
//    leaveMessageId INTEGER,
//    leaveGroupName TEXT,
//    inviteUserId INTEGER,
//    contactId INTEGER,
//    infoTimestamp INTEGER
        res = await groupUserUpdateProperty(
          [
            'id',
            'groupId',
            'lastReadMsgId',
            'lastDeleteMsgId',
            'leaveMessageId',
            'infoTimestamp'
          ],
          ['userId', 'contactId'],
          [
            row.id,
            row.groupId,
            row.lastReadMsgId,
            row.lastDeleteMsgId,
            row.leaveMessageId,
            row.infoTimestamp
          ],
          [row.userId, row.contactId],
        );
      }
    } else {
      res = await groupUserAdd(row);
    }
    return res;
  }

  groupUserDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(groupUser, where: 'id = ?', whereArgs: [id]);
  }

  groupUserDeleteByContactId(int id) async {
    Database db = await instance.database;
    return await db.delete(groupUser, where: 'contactId = ?', whereArgs: [id]);
  }

  groupUserDeleteCondition(String conditionStr, List valueArr) async {
    Database db = await instance.database;
    int count = await db.rawDelete(
        'DELETE FROM $groupUser WHERE $conditionStr', valueArr);
    return count;
  }

  groupUserOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?,';
      }
    }
    logger.d(conditionStr);
    var res = await db.query(groupUser,
        where: "$conditionStr", whereArgs: conditionValueArr);
    return res.isNotEmpty ? GroupUserSql.fromMap(res.first) : null;
  }

  groupUserMultipleCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res;
    try {
      res = await db.query(groupUser,
          where: "$conditionStr", whereArgs: conditionValueArr);
    } catch (e) {
      logger.d(e);
    }
    return res != null ? res : null;
  }

  groupUserMultipleQuery(String conditionStr) async {
    Database db = await instance.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM $groupUser WHERE $conditionStr');
    return list.length > 0 ? list : null;
  }

  groupUserQueryByString(String conditionStr) async {
//    var strC = '''contactId =${chat['contactId']}
//    AND contactId = ${chat['contactId']}''';
    Database db = await instance.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM $groupUser WHERE $conditionStr');
    return list.length > 0 ? list : null;
  }

  groupUserMerge(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
//    Database db = await instance.database;
    String cond = '';
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        cond += condition[i] + '= ${conditionValueArr[i]}';
      } else {
        cond += condition[i] + '=${conditionValueArr[i]} AND ';
      }
    }
    var index = await groupUserQueryByString(cond);
    var res;
    if (index != null) {
      res = await groupUserUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await groupUserInsertProperty(
          property, condition, propertyValueArr, conditionValueArr);
    }
    return res;
  }

  groupUserUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=? AND ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    int count = await db.rawUpdate(
        'UPDATE $groupUser SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  groupUserInsertProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    var propertyAll = [...property, ...condition];
    var conditionAll = [...propertyValueArr, ...conditionValueArr];
    for (var i = 0; i < propertyAll.length; i++) {
      if (i == propertyAll.length - 1) {
        propertyStr += propertyAll[i];
        valuesStr += '?';
      } else {
        propertyStr += propertyAll[i] + ',';
        valuesStr += '?, ';
      }
    }
    var valueArr = conditionAll;

    int count = await db.rawInsert(
        'INSERT INTO  $groupUser ($propertyStr) VALUES ($valuesStr)', valueArr);
    return count;
  }

  //  groupMessage
  groupMessageAll() async {
    Database db = await instance.database;
    var res = await db.query(groupMessage);
    return res;
  }

  groupMessageOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(groupMessage, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? GroupMessageSql.fromMap(res.first) : null;
  }

  groupMessageOneByTimestamp(int t) async {
    Database db = await instance.database;
    var res =
        await db.query(groupMessage, where: "timestamp = ?", whereArgs: [t]);
    return res.isNotEmpty ? res : null;
  }

  groupMessageByPage(String conditionStr) async {
    Database db = await instance.database;
//    var conditionStr = '';
//    for (var i = 0; i < conditionArr.length; i++) {
//      if (i == conditionArr.length - 1) {
//        conditionStr += conditionArr[i] + '=${conditionValueArr[i]}';
//      } else {
//        conditionStr += conditionArr[i] + '=${conditionValueArr[i]} AND ';
//      }
//    }
    List<Map> list =
        await db.rawQuery('SELECT * FROM $groupMessage WHERE $conditionStr');

    return list.length > 0 ? list : null;
  }

  groupMessageAdd(GroupMessageSql row) async {
    Database db = await instance.database;
    return await db.insert(groupMessage, row.toMap());
  }

  groupMessageUpdate(GroupMessageSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db.update(groupMessage, row.toMap(),
          where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  groupMessageUpdateOrInsert(GroupMessageSql row) async {
    var index = await groupMessageOne(row.id);
    var res;
    if (index != null) {
      res = await groupMessageUpdate(row);
    } else {
      res = await groupMessageAdd(row);
    }
    return res;
  }

  groupMessageDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(groupMessage, where: 'id = ?', whereArgs: [id]);
  }

//  多个条件删除 对话消息
  groupMessageDeleteMultiple(List condition, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=? ';
      } else {
        conditionStr += condition[i] + '=? AND ';
      }
    }
    var valueArr = conditionValueArr;
    int count = await db.rawDelete(
        'DELETE FROM $groupMessage WHERE $conditionStr', valueArr);
    return count;
  }

  groupMessageQueryByStr(String condition) async {
    Database db = await instance.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM $groupMessage WHERE $condition');

    return list.length > 0 ? list : null;
  }

  groupMessageMultipleCondition(List conditionArr, List conditionValueArr,
      {String conditionAll}) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=${conditionValueArr[i]} ';
      } else {
        conditionStr += conditionArr[i] + '=${conditionValueArr[i]} AND ';
      }
    }
    List<Map> list =
        await db.rawQuery('SELECT * FROM $groupMessage WHERE $conditionStr');

    return list.length > 0 ? list : null;
  }

  groupMessageUpdateOrInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
//    Database db = await instance.database;
    String cond = '';
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        cond += condition[i] + '= ${conditionValueArr[i]}';
      } else {
        cond += condition[i] + '=${conditionValueArr[i]} AND ';
      }
    }
    var index = await groupMessageQueryByStr(cond);
    var res;
    if (index != null) {
      res = await groupMessageUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await groupMessageInsertProperty(
          property, condition, propertyValueArr, conditionValueArr);
    }
    return res;
  }

  groupMessageInsertProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
    Database db = await instance.database;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    var propertyAll = [...property, ...condition];
    var conditionAll = [...propertyValueArr, ...conditionValueArr];
    for (var i = 0; i < propertyAll.length; i++) {
      if (i == propertyAll.length - 1) {
        propertyStr += propertyAll[i];
        valuesStr += '?';
      } else {
        propertyStr += propertyAll[i] + ',';
        valuesStr += '?, ';
      }
    }
    var valueArr = conditionAll;

    int count = await db.rawInsert(
        'INSERT INTO  $groupMessage ($propertyStr) VALUES ($valuesStr)',
        valueArr);
    return count;
  }

  groupMessageUpdateProperty(List property, List condition,
      List propertyValueArr, List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=? AND ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    var count;
    try {
      count = await db.rawUpdate(
          'UPDATE $groupMessage SET $propertyStr WHERE $conditionStr',
          valueArr);
    } catch (e) {}
    return count;
  }

  //  FILE
  fileAll() async {
    Database db = await instance.database;
    var res = await db.query(fileTable);
    return res;
  }

  fileOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(fileTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? FileSql.fromMap(res.first) : null;
  }

  fileOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(fileTable,
        where: "$conditionStr", whereArgs: [conditionValueArr]);
    return res.isNotEmpty ? FileSql.fromMap(res.first) : null;
  }

  fileAdd(FileSql row) async {
    Database db = await instance.database;
    return await db.insert(fileTable, row.toMap());
  }

  fileUpdate(FileSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db
          .update(fileTable, row.toMap(), where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  fileUpdateOrInsert(FileSql row) async {
    var index = await fileOne(row.id);
    var res;
    if (index != null) {
      res = await fileUpdate(row);
    } else {
      res = await fileAdd(row);
    }
    return res;
  }

  fileDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(fileTable, where: 'id = ?', whereArgs: [id]);
  }

  fileUpdateProperty(List property, List condition, List propertyValueArr,
      List conditionValueArr) async {
    Database db = await instance.database;

// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var conditionStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
      } else {
        propertyStr += property[i] + '=?, ';
      }
    }
    for (var i = 0; i < condition.length; i++) {
      if (i == condition.length - 1) {
        conditionStr += condition[i] + '=?';
      } else {
        conditionStr += condition[i] + '=?, ';
      }
    }
    var valueArr = [...propertyValueArr, ...conditionValueArr];
    int count = await db.rawUpdate(
        'UPDATE $fileTable SET $propertyStr WHERE $conditionStr', valueArr);
    return count;
  }

  fileInsertProperty(List property, List propertyValueArr) async {
    Database db = await instance.database;
    var res;
// condition : name = ?, value = ? WHERE groupId = ?
    var propertyStr = '';
    var valuesStr = '';
    for (var i = 0; i < property.length; i++) {
      if (i == property.length - 1) {
        propertyStr += property[i] + '=?';
        valuesStr += '?';
      } else {
        propertyStr += property[i] + '=?, ';
        valuesStr += '?, ';
      }
    }
    var valueArr = [...propertyValueArr];
    try {
      await db.transaction((txn) async {
        res = await txn.rawInsert(
            'INSERT INTO $fileTable ($propertyStr) VALUES($valuesStr)',
            valueArr);
      });
    } catch (e) {
      print(e);
    }
    return res;
  }

  fileUpdateOrInsertProperty(
      List property,
      List condition,
      List propertyValueArr,
      List conditionValueArr,
      List insertProperty,
      List insertPropertyArr) async {
//    Database db = await instance.database;
    var index = await fileOneCondition(condition, conditionValueArr);
    var res;
    if (index != null) {
      res = await fileUpdateProperty(
          property, condition, propertyValueArr, conditionValueArr);
    } else {
      // Insert some records in a transaction
      res = await fileInsertProperty(insertProperty, insertPropertyArr);
    }
    return res;
  }

  callAdd(List values) async {
    Database db = await instance.database;
    return await db.rawInsert('INSERT INTO $callTable (id, uuid, groupId, callerName) VALUES(?, ?, ?, ?)',
        [values[0], values[1], values[2], values[3]]);
  }

  callOne(String uuid) async {
    Database db = await instance.database;
    List<Map> list =
    await db.query(callTable, where: 'uuid = ?', whereArgs: [uuid]);

    return list.length > 0 ? list : null;
  }

  callQueryByStr(String condition) async {
    Database db = await instance.database;
    List<Map> list =
    await db.rawQuery('SELECT * FROM $callTable WHERE $condition');

    return list.length > 0 ? list : null;
  }

  deviceAll() async {
    Database db = await instance.database;
    var res = await db.query(deviceTable);
    return res;
  }

  deviceOne(int id) async {
    Database db = await instance.database;
    var res = await db.query(deviceTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? DeviceSql.fromMap(res.first) : null;
  }

  deviceOneCondition(List conditionArr, List conditionValueArr) async {
    Database db = await instance.database;
    var conditionStr = '';
    for (var i = 0; i < conditionArr.length; i++) {
      if (i == conditionArr.length - 1) {
        conditionStr += conditionArr[i] + '=?';
      } else {
        conditionStr += conditionArr[i] + '=?, ';
      }
    }
    var res = await db.query(deviceTable,
        where: "$conditionStr", whereArgs: [conditionValueArr]);
    return res.isNotEmpty ? DeviceSql.fromMap(res.first) : null;
  }

  deviceAdd(DeviceSql row) async {
    Database db = await instance.database;
    return await db.insert(deviceTable, row.toMap());
  }

  deviceUpdate(DeviceSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db
          .update(deviceTable, row.toMap(), where: "id = ?", whereArgs: [row.id]);
    } catch (e) {
      print(e);
    }
    return res;
  }

  deviceUpdateOrInsert(DeviceSql row) async {
    var index = await deviceOne(row.id);
    var res;
    if (index != null) {
      res = await deviceUpdate(row);
    } else {
      res = await deviceAdd(row);
    }
    return res;
  }

  deviceDelete(int id) async {
    Database db = await instance.database;
    return await db.delete(deviceTable, where: 'id = ?', whereArgs: [id]);
  }
  deviceDeleteByUser(int id) async {
    Database db = await instance.database;
    return await db.delete(deviceTable, where: 'userId = ?', whereArgs: [id]);
  }
  deviceGetByUser(int id) async {
    Database db = await instance.database;
    var res;
    res = await db.query(deviceTable, where: 'userId = ?', whereArgs: [id]);
    return res.length > 0 ? res : null;
  }


}
