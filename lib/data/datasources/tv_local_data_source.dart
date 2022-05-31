import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_tv.dart';
import 'package:ditonton/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlistTV(TVTable tv);
  Future<String> removeWatchlistTV(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTV();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelperTV databaseHelperTV;

  TVLocalDataSourceImpl({required this.databaseHelperTV});

  @override
  Future<String> insertWatchlistTV(TVTable tv) async {
    try {
      await databaseHelperTV.insertWatchlistTV(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTV(TVTable tv) async {
    try {
      await databaseHelperTV.removeWatchlistTV(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelperTV.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTV() async {
    final result = await databaseHelperTV.getWatchlistTV();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }
}
