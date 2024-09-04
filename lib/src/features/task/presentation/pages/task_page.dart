import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/constants/strings/paths.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/constants/theme/light/theme_light.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/task_priority.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/form_widgets.dart';
import 'package:maecha_tasks/src/utils/easy_loading_messages.dart';

class TaskPage extends StatefulWidget {
  final TaskModel? task;

  const TaskPage({super.key, this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  widget.task != null ? AppBar(
        backgroundColor: backgroundLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextLight),  // Icône personnalisée
          onPressed: () {
            BlocProvider.of<TaskBloc>(context).add(const GetTasksEvent());
            context.go(listTaskPath);
          },
        ),
      ):null,
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskLoadingState) {
                showCustomMessage(message: waiting);
              }

              if (state is TaskCreateSuccessState) {
                showCustomSuccess(message: state.message);
                context.go(listTaskPath);
                BlocProvider.of<TaskBloc>(context).add(const GetTasksEvent());
              }

              if (state is TitleExistState) {
                showCustomError(message: state.message);
              }

              if (state is TaskFailureState) {
                showCustomError(message: state.message);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(paddingPagesApp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task != null ? updateTask : createTask,
                    style: Theme.of(context).textTheme.displayLarge),
                const Gap(16),
                Text(descCreateTask,
                    style: Theme.of(context).textTheme.titleMedium),
                const Gap(16),
                _TaskForm(task: widget.task,)
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}


class _TaskForm extends StatefulWidget {
  final TaskModel? task;

  const _TaskForm({super.key,required this.task});

  @override
  State<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<_TaskForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  //names fields
  final String titleName="title";
  final String descName="desc";
  final String hourName="hour";
  final String dateName="date";

  //Controllers fields
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _descController=TextEditingController();
  final TextEditingController _hourController=TextEditingController();
  final TextEditingController _dateController=TextEditingController();

  //
  final FocusNode _titleFocusNode=FocusNode();
  final FocusNode _descFocusNode=FocusNode();
  final FocusNode _hourFocusNode=FocusNode();
  final FocusNode _dateFocusNode=FocusNode();
  final FocusNode _choiceFocusNode=FocusNode();

  //
  bool _notificationsEnabled = false;
  //
  DateTime _initialValueDate=DateTime.now();

  //
  String _initialValueColor=lowValue;

  String _priorityChanged=lowValue;


  late TaskModel taskRecover;

  @override
  void initState() {
     super.initState();
     //id != null ? BlocProvider.of<TaskBloc>(context).add(GetTaskEditEvent(idTask: id!)) :null;
     if(widget.task != null){
       setState(() {
         taskRecover = widget.task!;
         _titleController.text = taskRecover.title!;
         _descController.text = taskRecover.desc!;
         _notificationsEnabled = taskRecover.notify!;
         _initialValueDate = taskRecover.dateTime!;
         _initialValueColor = _getValueColorInFrench(taskRecover.priority!.name);

         // Mettre à jour les contrôleurs de date et d'heure
         _dateController.text = DateFormat('yyyy-MM-dd').format(_initialValueDate);
         _hourController.text = DateFormat('HH:mm').format(_initialValueDate);
       });
     }
  }

  void _onChangedNotifyValue(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              _buildTitleField(),
              const Gap(16),
              Row(children: [
                Expanded(child: _buildDateField()),
                const Gap(4),
                Expanded(child: _buildHourField()),
              ],),
              const Gap(16),
              _buildDescField(),
              const Gap(16),
              _buildColorChoice(),
              const Gap(16),
              SwitchListTile(
                tileColor: backgroundLight,
                activeColor: primaryLight,
                contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                title: Text("Activer les notifications pour cette tâche",style: Theme.of(context).textTheme.labelSmall,),
                value: _notificationsEnabled,
                onChanged:_onChangedNotifyValue,
              ),
              const Gap(16),
              BlocBuilder<ConnectivityCheckerBloc, ConnectivityCheckerState>(
                builder: (context, state) {
                  return ElevatedButton(
                onPressed: (){
                  if((_formKey.currentState?.saveAndValidate() ?? false)){
                    _logicToSave(state);
                  }
                },
                child: Text(widget.task != null ? "Editer":'Créer'),
              );
    },
        ),
            ],
          ),
        );

  }

  Widget _buildTitleField(){
    return  formBuilderTextField(
        formKey: _formKey,
        context: context,
        ctrl: _titleController,
        label: "Titre",
        textInputAction: TextInputAction.next,
        focusNode:  _titleFocusNode,
        name: "title",
        focused: true,
        validators: [
          requiredFieldForm(),
          FormBuilderValidators.minLength( 3, errorText: 'Le titre doit comporter au moins 3 caractères'),
        ]
    );
  }
  Widget _buildDescField(){
    return  formBuilderTextField(
        formKey: _formKey,
        context: context,
        ctrl: _descController,
        label: "Description",
        textInputAction: TextInputAction.next,
        focusNode:  _descFocusNode,
        name: descName,
        maxLines: 4,
        validators: [
          requiredFieldForm()
        ]
    );
  }
  Widget _buildDateField(){
    return  FormBuilderDateTimePicker(
      name: dateName,
      controller: _dateController,
      focusNode: _dateFocusNode,
      initialEntryMode: DatePickerEntryMode.calendar,
      inputType: InputType.date,
      initialValue: _initialValueDate,
      decoration: const InputDecoration(
        labelText: 'Date',
      ),
      validator: FormBuilderValidators.compose([
        requiredFieldForm()
      ]),
    );
  }
  Widget _buildHourField(){
    return FormBuilderDateTimePicker(
      name: hourName,
      controller: _hourController,
      initialEntryMode: DatePickerEntryMode.calendar,
      inputType: InputType.time,
      initialValue: _initialValueDate,
      focusNode: _hourFocusNode,
      decoration: const InputDecoration(
        labelText: 'Heure',
      ),
      validator: FormBuilderValidators.compose([
        requiredFieldForm()
      ]),
    );
  }
  Widget _buildColorChoice(){
    return  FormBuilderChoiceChip<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      backgroundColor: backgroundLight,
      labelStyle: hintStyle,
      spacing: 3,
      focusNode: _choiceFocusNode,
      decoration: const InputDecoration(
        iconColor: backgroundLight,
          labelText:'Priorité',
      ),
      name: 'priority',
      validator: FormBuilderValidators.compose([
        requiredFieldForm()
      ]),
      initialValue: _initialValueColor,
      options: const [
        FormBuilderChipOption(
          value:  lowValue,
          avatar: CircleAvatar(
            backgroundColor: lowPriorityColor,
          ),
        ),
        FormBuilderChipOption(
          value: mediumValue,
          avatar: CircleAvatar(
            backgroundColor: mediumPriorityColor,
          ),
        ),
        FormBuilderChipOption(
          value: highValue,
          avatar: CircleAvatar(
            backgroundColor: highPriorityColor,
          ),
        ),
      ],
      onChanged: _onChanged,
    );
  }

  void _onChanged(dynamic val) => setState(() {
    _priorityChanged= val.toString();
  });

  TaskPriority _convertFormValuePriority(String value){
    late TaskPriority vl;
    switch(value){
      case lowValue:
        vl=TaskPriority.low;
        break;
      case highValue :
        vl=TaskPriority.high;
        break;
      case mediumValue :
       vl=TaskPriority.medium;
       break;
    }

    return vl;
  }

  _logicToSave(ConnectivityCheckerState state) {
    final formValues=_formKey.currentState?.value;

    TaskModel task=TaskModel.addTask(
        title: formValues!['title'],
        desc: formValues['desc'],
        dateTime: combineDateAndTime(formValues['date'].toString(), formValues['hour'].toString()),
        priority: _convertFormValuePriority(_priorityChanged),
        notify: _notificationsEnabled,
        done: false
    );
    //en cas de connection
    if(state is ConnectionInternetState){
      if(widget.task != null){
        //Ajout de l'id
        TaskModel updatedTask= task.copyWith(id: taskRecover.id!);
        //Mise à jour
        BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(task: updatedTask));
      }else{
        //Création
        BlocProvider.of<TaskBloc>(context).add(CreateTaskRemoteEvent(task: task));
      }
    }
    //Pas de connexion
    if(state is NoConnectionInternetState){
      //Création en local
      BlocProvider.of<TaskBloc>(context).add(CreateTaskLocaleEvent(task: task));
    }
  }

  @override
  void dispose() {
    // Ne pas oublier de nettoyer les contrôleurs et focus nodes pour éviter les fuites de mémoire
    _titleController.dispose();
    _descController.dispose();
    _hourController.dispose();
    _dateController.dispose();
    _titleFocusNode.dispose();
    _descFocusNode.dispose();
    _hourFocusNode.dispose();
    _dateFocusNode.dispose();
    _choiceFocusNode.dispose();
    super.dispose();
  }

 String _getValueColorInFrench(String frenchValue){
    switch(frenchValue){
      case "low":
        return lowValue;
      case  "medium":
        return mediumValue;
      default:
        return highValue;
    }
 }




}