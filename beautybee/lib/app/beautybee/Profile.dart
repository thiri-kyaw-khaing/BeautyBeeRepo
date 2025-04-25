import 'package:beautybee/app/auth_service.dart';
import 'package:beautybee/app/providers/User_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final auth = AuthService();
  final displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final name = auth.currentUser?.displayName ?? "";
    displayNameController.text = name;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final userProvider=Provider.of<UserProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 80),
            const SizedBox(height: 10),
            Text(
              user?.email ?? "No email",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Username: ${userProvider.displayName.isNotEmpty ? userProvider.displayName : "Guest"}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Update Display Name",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: displayNameController,
                              decoration: const InputDecoration(
                                labelText: "New Display Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.save,color: Colors.white,),
                              label: const Text("Save",style: TextStyle(color: Colors.white),),
                              onPressed: () async {
                                try {
                                  final name = displayNameController.text.trim();
                                  await auth.updateUsername(name);
                                  userProvider.updateName(name);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Username updated")),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent
                ),
                icon: const Icon(Icons.save),
                label: const Text("Update Name",style: TextStyle(color: Colors.white),),
              ),
            ),


            const SizedBox(height: 10),

            // // Reset password
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     try {
            //       if (user?.email != null) {
            //         await auth.resetPassword(user!.email!);
            //         _showSnack("Reset email sent.");
            //       } else {
            //         _showSnack("No email available.");
            //       }
            //     } catch (e) {
            //       _showSnack("Error: $e");
            //     }
            //   },
            //   icon: const Icon(Icons.lock_reset),
            //   label: const Text("Reset Password"),
            // ),

            // const Spacer(),

            // Delete account
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await auth.deleteAccount();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/signup');
                    }
                  } catch (e) {
                    _showSnack("Error: $e");
                  }
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text("Delete Account"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  } catch (e) {
                    _showSnack("Logout failed: $e");
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
