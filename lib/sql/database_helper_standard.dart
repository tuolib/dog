import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../index.dart';

class DatabaseHelperStandard {
  static final _databaseName = "MyDatabase.db";

//  static final _databaseVersion = 1;
  static final _databaseVersion = 4;
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

//  static final tableChatList = 'tableChatList';

  // make this a singleton class
  DatabaseHelperStandard._privateConstructor();

  static final DatabaseHelperStandard instance = DatabaseHelperStandard._privateConstructor();

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
//    userTable
    await db.execute('''
          CREATE TABLE $userTable (
            id INTEGER PRIMARY KEY,
            username TEXT,
            email TEXT,
            avatar INTEGER,
            firstName TEXT,
            lastName TEXT
          )
          ''');
//    groupRoom
    await db.execute('''
          CREATE TABLE $groupRoom (
            id INTEGER PRIMARY KEY,
            groupType INTEGER,
            groupName TEXT,
            createdDate TEXT,
            avatar INTEGER
          )
          ''');
//    groupUser
    await db.execute('''
          CREATE TABLE $groupUser (
            id INTEGER PRIMARY KEY,
            groupId INTEGER,
            userId INTEGER,
            lastReadMsgId INTEGER,
            isQuit INTEGER,
            showChat INTEGER,
            lastClearMsgId INTEGER
          )
          ''');
//    groupMessage
    await db.execute('''
          CREATE TABLE $groupMessage (
            id INTEGER PRIMARY KEY,
            groupId INTEGER,
            senderId INTEGER,
            createdDate TEXT,
            content TEXT,
            contentType INTEGER,
            contentId INTEGER,
            contentName TEXT,
            isReply INTEGER,
            replyId INTEGER,
            timestamp INTEGER
          )
          ''');
//    file table
    await db.execute('''
        CREATE TABLE $fileTable (
          id INTEGER PRIMARY KEY,
          name TEXT,
          fileName TEXT,
          fileSize INTEGER,
          fileOriginUrl TEXT,
          fileOriginLocal TEXT,
          fileCompressUrl TEXT,
          fileCompressLocal TEXT
        )
      ''');
//    contacts
    await db.execute('''
          CREATE TABLE $contactsTable (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            contactId INTEGER,
            firstName TEXT,
            lastName TEXT
          )
          ''');
//    chatListTable
    await db.execute('''
          CREATE TABLE $chatListTable (
            groupId INTEGER PRIMARY KEY,
            contactId INTEGER,
            groupType INTEGER,
            groupAvatar TEXT,
            groupAvatarLocal TEXT,
            avatarName TEXT,
            groupName TEXT,
            username TEXT,
            createdDate TEXT,
            content TEXT,
            isOnline INTEGER,
            newChatNumber INTEGER,
            groupUserLength INTEGER,
            contentName TEXT,
            contentType INTEGER,
            sendName TEXT
          )
          ''');
//    example table
    await db.execute('''
          CREATE TABLE $table (
            '_id' INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
    print("Created tables");
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
  getContactsAll() async {
    Database db = await instance.database;
    var res = await db.query(contactsTable);
    return res;
  }
  getContactOne(int contactId) async {
    Database db = await instance.database;
    var res = await db
        .query(contactsTable, where: "contactId = ?", whereArgs: [contactId]);
    return res.isNotEmpty ? ContactSql.fromMap(res.first) : null;
  }
  addContacts(ContactSql row) async {
    Database db = await instance.database;
    return await db.insert(contactsTable, row.toMap());
  }
  updateContact(ContactSql row) async {
    Database db = await instance.database;
    var res;
    try {
      res = await db.update(contactsTable, row.toMap(),
          where: "contactId = ?", whereArgs: [row.contactId]);
    } catch (e) {
      print(e);
    }
    return res;
  }
  deleteContacts(int contactId) async {
    Database db = await instance.database;
    return await db
        .delete(contactsTable, where: 'contactId = ?', whereArgs: [contactId]);
  }
  contactListUpdateMultiple(String condition, List valueArr, int contactId) async {
    Database db = await instance.database;
// condition : name = ?, value = ? WHERE contactId = ?
    int count =
    await db.rawUpdate('UPDATE $contactsTable SET $condition', valueArr);
    return count;
  }

//  user
}
