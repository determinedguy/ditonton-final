import 'dart:convert';
import 'dart:io';

import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockIOClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockIOClient();
    dataSource = TVRemoteDataSourceImpl(ioClient: mockHttpClient);
  });

  group('get Now Playing TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/on_the_air_tv.json')))
        .tvList;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/on_the_air_tv.json'), 200));
      // act
      final result = await dataSource.getNowPlayingTV();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Shows', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/popular_tv.json')))
            .tvList;

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_tv.json'), 200));
      // act
      final result = await dataSource.getPopularTV();
      // assert
      expect(result, tTVList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv.json')))
        .tvList;

    test('should return list of tv shows when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200));
      // act
      final result = await dataSource.getTopRatedTV();
      // assert
      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    final tId = 1;
    final tTVDetail = TVDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTVDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));
      // act
      final result = await dataSource.getTVRecommendations(tId);
      // assert
      expect(result, equals(tTVList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('dummy_data/search_squid_game_tv.json')))
        .tvList;
    final tQuery = 'Squid Game';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_squid_game_tv.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.searchTV(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTV(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
