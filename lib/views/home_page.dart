import 'package:flutter/material.dart';
import 'package:flutter_api_handler/api/repositories/api_repository.dart';
import 'package:flutter_api_handler/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_api_handler/api/bloc/bloc.dart';

class HomePage extends StatelessWidget {
  List<UserModel> userModel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Request Example'),
      ),
      body: BlocProvider(
        create: (context) => ApiBloc(methods: 'users', requestType: RequestType.GET, context: context),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiEmpty) {
              BlocProvider.of<ApiBloc>(context).add(FetchApi());
            }
            if (state is ApiError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('Error connection with server, please try again later')),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ApiBloc>(context).add(FetchApi());
                      },
                      child: Text('Reload', style: TextStyle(decoration: TextDecoration.underline),),
                    ),
                  )
                ],
              );
            }
            if (state is ApiNetworkError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('No internet connection, please try again later')),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ApiBloc>(context).add(FetchApi());
                      },
                      child: Text('Reload', style: TextStyle(decoration: TextDecoration.underline),),
                    ),
                  )
                ],
              );
            }
            if (state is ApiLoaded) {
              List item = state.response;
              item.forEach((element) {
                userModel.add(UserModel.fromJson(element));
              });
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<ApiBloc>(context).add(FetchApi());
                },
                child: userModel.isNotEmpty ? ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('${index + 1}. ' + userModel[index].name),
                    );
                  },
                ) : Center(
                  child: Text('Member is empty'),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
