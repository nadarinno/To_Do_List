import 'package:flutter/material.dart';
import 'package:todolist/controller/todolist_controller.dart';
import 'package:todolist/logic/todolist_logic.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController controller = TaskController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await controller.getTasks();
    setState(() {});
  }

  void showAddDialog() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter task...",
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFBA63CE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                await controller.addTask(textController.text);
                loadTasks();
                Navigator.pop(context);
              }
            },
            child: Text("Add",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void showEditDialog(Task task) {
    TextEditingController editController =
    TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Edit Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: editController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              task.title = editController.text;
              await controller.updateTask(task);
              loadTasks();
              Navigator.pop(context);
            },
            child: Text("Save",
              style: TextStyle(
              color: Colors.white, // change text color here

            ),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF9C27B0),
        child: Icon(Icons.add),
        onPressed: showAddDialog,
      ),
      body: tasks.isEmpty
          ? Center(
        child: Text(
          "No Tasks Yet ✨",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            color: Color(0xFF1E1E1E),
            elevation: 6,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: task.isDone == 1
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              leading: Checkbox(
                activeColor: Color(0xFFBB86FC),
                value: task.isDone == 1,
                onChanged: (_) async {
                  await controller.toggleTask(task);
                  loadTasks();
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: Color(0xFFBB86FC)),
                    onPressed: () =>
                        showEditDialog(task),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: Colors.redAccent),
                    onPressed: () async {
                      await controller
                          .deleteTask(task.id!);
                      loadTasks();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}