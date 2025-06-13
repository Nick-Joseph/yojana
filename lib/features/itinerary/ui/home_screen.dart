import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../itinerary/bloc/itinerary_bloc.dart';
import '../../itinerary/models/itinerary.dart';

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
    // Listen for navigation back to this screen and reload itineraries
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryBloc>().add(LoadItineraries('userId'));
      GoRouter.of(context).routerDelegate.addListener(() {
        final currentLocation = GoRouter.of(
          context,
        ).routerDelegate.currentConfiguration.uri.toString();
        if (currentLocation == '/home') {
          context.read<ItineraryBloc>().add(LoadItineraries('userId'));
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        context.push('/itinerary');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ItineraryBloc, ItineraryState>(
                    builder: (context, state) {
                      debugPrint('ItineraryBloc state: ' + state.toString());
                      if (state is ItineraryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ItineraryLoaded) {
                        debugPrint(
                          'Loaded itineraries: ' +
                              state.itineraries.length.toString(),
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
                                'Rendering itinerary: ' + itinerary.title,
                              );
                              return _ItineraryCard(itinerary: itinerary);
                            },
                          ),
                        );
                      } else if (state is ItineraryError) {
                        debugPrint('ItineraryBloc error: ' + state.error);
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
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;
  const _ItineraryCard({required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final friendsCount = itinerary.travelers.length;
    final tripDays =
        itinerary.endDate.difference(itinerary.startDate).inDays + 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          itinerary.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Destination: ${itinerary.destination}'),
                const SizedBox(width: 16),
                Text('Days: $tripDays'),
              ],
            ),
            Row(
              children: [
                Text(
                  '${dateFormat.format(itinerary.startDate)} - ${dateFormat.format(itinerary.endDate)}',
                ),
                const SizedBox(width: 16),
                Text('Friends: $friendsCount'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/itinerary', extra: itinerary);
        },
      ),
    );
  }
}
