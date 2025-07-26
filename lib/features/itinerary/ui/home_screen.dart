import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yojana/core/utlis/shimmer.dart';
import 'package:yojana/features/itinerary/ui/itinerary_card.dart';
import '../../itinerary/bloc/itinerary_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ItineraryBloc>().add(LoadItineraries('userId'));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItineraryBloc, ItineraryState>(
      listenWhen: (previous, current) =>
          current is SaveItinerary || current is DeleteItinerary,
      listener: (context, state) {
        // TODO: implement listener
        if (state is SaveItinerary || state is DeleteItinerary) {
          context.read<ItineraryBloc>().add(LoadItineraries('userId'));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Itinerary updated!')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yojana'),
          leading: IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // Message box action (to be implemented)
            },
          ),
        ),
        body: _selectedIndex == 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Create Itinerary'),
                        onPressed: () {
                          context.push('/createitinerary');
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ItineraryBloc, ItineraryState>(
                      builder: (context, state) {
                        debugPrint('ItineraryBloc state: $state');
                        if (state is ItineraryLoading) {
                          return const Center(child: ShimmerPage());
                        } else if (state is ItineraryLoaded) {
                          debugPrint(
                            'Loaded itineraries: ${state.itineraries.length}',
                          );
                          if (state.itineraries.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.list_alt,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'No itineraries yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<ItineraryBloc>().add(
                                LoadItineraries('userId'),
                              );
                            },
                            child: ListView.builder(
                              itemCount: state.itineraries.length,
                              itemBuilder: (context, index) {
                                final itinerary = state.itineraries[index];
                                debugPrint(
                                  'Rendering itinerary: ${itinerary.title}',
                                );
                                return ItineraryCard(itinerary: itinerary);
                              },
                            ),
                          );
                        } else if (state is ItineraryError) {
                          debugPrint('ItineraryBloc error: ${state.error}');
                          return Center(child: Text('Error: ${state.error}'));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              )
            : _selectedIndex == 1
            ? Center(child: Text('Friends'))
            : Center(child: Text('Settings')),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
