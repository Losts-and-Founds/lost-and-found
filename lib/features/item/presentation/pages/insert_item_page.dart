import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:lost_and_found/core/presentation/app_global/bloc/app_global_bloc.dart';
import 'package:lost_and_found/core/presentation/home_controller/bloc/home_controller_bloc.dart';
import 'package:lost_and_found/core/presentation/select_position/pages/select_position_page.dart';
import 'package:lost_and_found/core/presentation/widgets/confirm_exit_dialog.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/features/item/domain/entities/user_item.dart';
import 'package:lost_and_found/features/item/presentation/bloc/home/home_bloc.dart';
import 'package:lost_and_found/features/item/presentation/bloc/insert_item/insert_item_bloc.dart';
import 'package:lost_and_found/injection_container.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';
import 'package:lost_and_found/utils/utility.dart';

class InsertItemScreen extends StatefulWidget {
  final bool isNewItemLost;
  final String? draftId;
  final Map<String, dynamic>? draftData;

  const InsertItemScreen({
    super.key,
    this.isNewItemLost = true,
    this.draftId,
    this.draftData,
  });

  @override
  State<InsertItemScreen> createState() => _InsertItemScreenState();
}

class _InsertItemScreenState extends State<InsertItemScreen> {
  int _currentStep = 1; // Step 1 of 3, 2 of 3, 3 of 3
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _electronicsIdentifierController =
      TextEditingController();

  String _selectedCategoryName = "Wallets & Purses";
  int _selectedCategoryId = 1;
  String _selectedElectronicsDeviceType = "phone";
  String _locationDisplay = "Select a location";
  String? _draftId;

  final List<Map<String, dynamic>> _categories = const [
    {"id": 1, "name": "Wallets & Purses", "icon": Icons.wallet_rounded},
    {"id": 2, "name": "Electronics & Gadgets", "icon": Icons.devices_rounded},
    {"id": 3, "name": "Keys & Access Cards", "icon": Icons.vpn_key_rounded},
    {"id": 4, "name": "Bags & Backpacks", "icon": Icons.backpack_rounded},
    {
      "id": 5,
      "name": "Clothing & Accessories",
      "icon": Icons.checkroom_rounded
    },
    {"id": 6, "name": "Documents & IDs", "icon": Icons.description_rounded},
    {"id": 7, "name": "Other Valuables", "icon": Icons.category_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _draftId = widget.draftId;
    final draft = widget.draftData;
    if (draft == null) return;

    _titleController.text = draft['title'] as String? ?? '';
    _questionController.text = draft['question'] as String? ?? '';
    _electronicsIdentifierController.text =
        draft['electronicsIdentifier'] as String? ?? '';
    _selectedCategoryId = _readInt(draft['categoryId']) ?? 1;
    _selectedCategoryName =
        draft['category'] as String? ?? _categoryName(_selectedCategoryId);
    _selectedElectronicsDeviceType =
        draft['electronicsDeviceType'] as String? ?? 'phone';
    final location = draft['location'] as Map<String, dynamic>?;
    final locationLabel = location?['label'] as String? ?? '';
    if (locationLabel.isNotEmpty && !_isCoordinateLabel(locationLabel)) {
      _locationDisplay = locationLabel;
    }
  }

  int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  double? _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool _isCoordinateLabel(String value) {
    final parts = value.split(',');
    return parts.length == 2 &&
        double.tryParse(parts[0].trim()) != null &&
        double.tryParse(parts[1].trim()) != null;
  }

  String _categoryName(int id) {
    for (final category in _categories) {
      if (category['id'] == id) return category['name'] as String;
    }
    return 'Other Valuables';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
    _electronicsIdentifierController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, BuildContext blocContext) async {
    try {
      final img = await _picker.pickImage(source: source);
      if (img != null && mounted) {
        blocContext
            .read<InsertItemBloc>()
            .add(InsertItemEvent.imageSelected(img.path));
      }
    } catch (_) {}
  }

  void _showMediaPickerSheet(BuildContext blocContext) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          customColors.cardFill ?? Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.modalTop)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Upload Photo",
                style: AppTypography.serifHeading(context, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title:
                    Text("Take Photo", style: AppTypography.sansBody(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.camera, blocContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text("Choose from Gallery",
                    style: AppTypography.sansBody(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.gallery, blocContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPickerSheet(BuildContext blocContext) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          customColors.cardFill ?? Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.modalTop)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                "Select Category",
                style: AppTypography.serifHeading(context, fontSize: 20),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat["name"] == _selectedCategoryName;

                  return ListTile(
                    leading: Icon(cat["icon"] as IconData,
                        color: isSelected ? mintColor : null),
                    title: Text(
                      cat["name"] as String,
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 15,
                        color: isSelected ? mintColor : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: mintColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCategoryName = cat["name"] as String;
                        _selectedCategoryId = cat["id"] as int;
                      });
                      blocContext.read<InsertItemBloc>().add(
                            InsertItemEvent.categorySelected(
                                _selectedCategoryId, _selectedCategoryName),
                          );
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveDraft(InsertItemState state) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showBasicInfoSnackbar(context, "Sign in to save a draft.");
      return;
    }

    try {
      final position = state.pos.value.getOrElse(() => const LatLng(0, 0));
      final drafts = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('drafts');
      final draftReference =
          _draftId == null ? drafts.doc() : drafts.doc(_draftId);
      await draftReference.set({
        'title': _titleController.text.trim(),
        'status': state.type.name,
        'categoryId': _selectedCategoryId,
        'category': _selectedCategoryName,
        'question': _questionController.text.trim(),
        'electronicsDeviceType':
            _selectedCategoryId == 2 ? _selectedElectronicsDeviceType : null,
        'electronicsIdentifier': _selectedCategoryId == 2
            ? _electronicsIdentifierController.text.trim()
            : null,
        'imagePath': state.imagePath,
        'location': {
          'label': state.address.isNotEmpty
              ? state.address
              : _locationDisplay == 'Select a location' ||
                      _isCoordinateLabel(_locationDisplay)
                  ? ''
                  : _locationDisplay,
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        'savedAt': FieldValue.serverTimestamp(),
      });
      _draftId = draftReference.id;
      if (mounted) {
        showBasicSuccessSnackbar(context, "Draft saved to Drafts.");
      }
    } on FirebaseException catch (error) {
      debugPrint('Could not save item draft: $error');
      if (mounted) {
        showBasicInfoSnackbar(context, "Could not save the draft. Try again.");
      }
    }
  }

  void _onClose() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmExitDialog(
        onConfirm: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor =
        customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final containerFill = customColors.cardFill ??
        (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ??
        (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));
    final textPrimary = customColors.textPrimary ??
        (isDark ? Colors.white : const Color(0xFF1E232A));
    final urgentColor =
        isDark ? const Color(0xFFA61C32) : const Color(0xFF1E232A);

    return BlocBuilder<AppGlobalBloc, AppGlobalState>(
      builder: (appGlobalCtx, appGlobalState) => BlocProvider<InsertItemBloc>(
        create: (_) {
          final draft = widget.draftData;
          final isDraftLost =
              draft == null ? widget.isNewItemLost : draft['status'] != 'found';
          final bloc = sl<InsertItemBloc>()
            ..add(InsertItemEvent.contentCreated(isDraftLost));
          if (draft != null) {
            bloc.add(
                InsertItemEvent.titleChanged(draft['title'] as String? ?? ''));
            bloc.add(InsertItemEvent.questionChanged(
                draft['question'] as String? ?? ''));
            bloc.add(InsertItemEvent.categorySelected(
              _selectedCategoryId,
              _selectedCategoryName,
            ));

            final location = draft['location'] as Map<String, dynamic>?;
            final latitude = _readDouble(location?['latitude']);
            final longitude = _readDouble(location?['longitude']);
            if (latitude != null &&
                longitude != null &&
                (latitude != 0 || longitude != 0)) {
              bloc.add(InsertItemEvent.positionSelected(
                LatLng(latitude, longitude),
              ));
            }

            final imagePath = draft['imagePath'] as String?;
            if (imagePath != null && File(imagePath).existsSync()) {
              bloc.add(InsertItemEvent.imageSelected(imagePath));
            }
          }
          return bloc;
        },
        child: BlocConsumer<InsertItemBloc, InsertItemState>(
          listener: (ctx, state) async {
            final insertFailureOrSuccess = state.insertFailureOrSuccess;
            if (insertFailureOrSuccess != null) {
              insertFailureOrSuccess.fold(
                (failure) => showBasicErrorSnackbar(context, failure),
                (_) async {
                  var draftCleanupSucceeded = true;
                  if (_draftId != null) {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId != null) {
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('drafts')
                            .doc(_draftId)
                            .delete();
                      } on FirebaseException catch (error) {
                        debugPrint(
                            'Report published but draft cleanup failed: $error');
                        draftCleanupSucceeded = false;
                      }
                    }
                  }
                  if (!ctx.mounted) return;
                  showBasicSuccessSnackbar(
                    ctx,
                    draftCleanupSucceeded
                        ? "Report published successfully!"
                        : "Report published, but the draft could not be removed.",
                  );
                  ctx
                      .read<HomeBloc>()
                      .add(HomeEvent.homeSectionRefreshed(state.type));
                  ctx
                      .read<HomeControllerBloc>()
                      .add(const HomeControllerEvent.tabChanged(0));
                  Navigator.of(ctx).pop();
                },
              );
            }
          },
          builder: (ctx, state) {
            final isLost = state.type == ItemType.lost;

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Close button ('X')
                        IconButton(
                          icon: Icon(Icons.close_rounded,
                              size: 24, color: textPrimary),
                          onPressed: _onClose,
                          splashRadius: 22,
                        ),

                        // Progress Indicator ("Step 1 of 3", etc.)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Step $_currentStep of 3",
                              style: AppTypography.sansBold(context,
                                  fontSize: 13, color: textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (idx) {
                                final active = idx < _currentStep;
                                return Container(
                                  width: 22,
                                  height: 3,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? mintColor
                                        : secondaryTextColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        // "Save draft" action button
                        TextButton(
                          onPressed: () => _onSaveDraft(state),
                          style: TextButton.styleFrom(
                            foregroundColor: mintColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                          ),
                          child: Text(
                            "Save draft",
                            style: AppTypography.sansBold(context,
                                fontSize: 13, color: mintColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_currentStep == 1) ...[
                        // ========================================================
                        // STEP 1: Basic Info & Photos
                        // ========================================================

                        // 1. Photo Upload Zone: Dashed rounded rectangle container
                        _buildPhotoUploadZone(context, ctx, state, mintColor,
                            borderColor, secondaryTextColor),
                        const SizedBox(height: 20),

                        // 2. Item Type Selector: Toggle between "Lost" (Active state fill) and "Found" (Inactive outline)
                        _buildItemTypeToggle(context, ctx, isLost, mintColor,
                            urgentColor, borderColor),
                        const SizedBox(height: 22),

                        // 3. TITLE: Item title
                        Text(
                          "TITLE",
                          style: AppTypography.uppercaseLabel(context,
                              fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: containerFill,
                            borderRadius:
                                BorderRadius.circular(AppRadius.input),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: TextFormField(
                            controller: _titleController,
                            style:
                                AppTypography.sansBody(context, fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: "e.g. Wallet, keys, or phone",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                            onChanged: (val) {
                              ctx
                                  .read<InsertItemBloc>()
                                  .add(InsertItemEvent.titleChanged(val));
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. CATEGORY: Functional dropdown selection menu with tag icon ("Wallets & Purses")
                        Text(
                          "CATEGORY",
                          style: AppTypography.uppercaseLabel(context,
                              fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _showCategoryPickerSheet(ctx),
                          child: Container(
                            decoration: BoxDecoration(
                              color: containerFill,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.input),
                              border:
                                  Border.all(color: borderColor, width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Icon(Icons.local_offer_outlined,
                                    size: 20, color: mintColor),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedCategoryName,
                                    style: AppTypography.sansBold(context,
                                        fontSize: 15, color: textPrimary),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down_rounded,
                                    size: 26, color: secondaryTextColor),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedCategoryId == 2) ...[
                          const SizedBox(height: 20),
                          Text(
                            "ELECTRONIC DEVICE",
                            style: AppTypography.uppercaseLabel(context,
                                fontSize: 11),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedElectronicsDeviceType,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: containerFill,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.input),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.input),
                                borderSide: BorderSide(color: borderColor),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: "phone", child: Text("Phone")),
                              DropdownMenuItem(
                                  value: "laptop", child: Text("Laptop")),
                            ],
                            onChanged: (deviceType) {
                              if (deviceType != null) {
                                setState(() {
                                  _selectedElectronicsDeviceType = deviceType;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _selectedElectronicsDeviceType == "phone"
                                ? "IMEI"
                                : "SSID NUMBER",
                            style: AppTypography.uppercaseLabel(context,
                                fontSize: 11),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: containerFill,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.input),
                              border:
                                  Border.all(color: borderColor, width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            child: TextFormField(
                              controller: _electronicsIdentifierController,
                              keyboardType:
                                  _selectedElectronicsDeviceType == "phone"
                                      ? TextInputType.number
                                      : TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              style:
                                  AppTypography.sansBody(context, fontSize: 16),
                              decoration: InputDecoration(
                                hintText:
                                    _selectedElectronicsDeviceType == "phone"
                                        ? "Enter the phone's IMEI"
                                        : "Enter the laptop's SSID number",
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // 5. LOCATION: Interactive picker container showing map tile preview, location text, radius, and chevron arrow
                        Text(
                          "LOCATION",
                          style: AppTypography.uppercaseLabel(context,
                              fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final LatLng? result =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SelectPositionScreen(
                                  startingPosition: state.pos.value.getOrElse(
                                      () => appGlobalState.defaultPosition),
                                  address: state.address,
                                ),
                              ),
                            );
                            if (result != null && mounted) {
                              ctx.read<InsertItemBloc>().add(
                                  InsertItemEvent.positionSelected(result));
                              setState(() {
                                _locationDisplay = 'Selected location';
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: containerFill,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.input),
                              border:
                                  Border.all(color: borderColor, width: 1.2),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Map tile preview sketch
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: mintColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: mintColor.withOpacity(0.3),
                                        width: 1),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.map_outlined,
                                          size: 32,
                                          color: mintColor.withOpacity(0.5)),
                                      Icon(Icons.location_on_rounded,
                                          size: 24, color: mintColor),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Location text & radius
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.address.isNotEmpty
                                            ? state.address
                                            : _locationDisplay,
                                        style: AppTypography.sansBold(context,
                                            fontSize: 14, color: textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded,
                                    size: 24, color: secondaryTextColor),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Next Step Button
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter a title")),
                                );
                                return;
                              }
                              ctx.read<InsertItemBloc>().add(
                                  InsertItemEvent.titleChanged(
                                      _titleController.text.trim()));
                              setState(() {
                                _currentStep = 2;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mintColor,
                              foregroundColor: isDark
                                  ? const Color(0xFF0B101D)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.button)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Next: Verification Details",
                                  style: AppTypography.sansBold(
                                    context,
                                    fontSize: 16,
                                    color: isDark
                                        ? const Color(0xFF0B101D)
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    size: 18),
                              ],
                            ),
                          ),
                        ),
                      ] else if (_currentStep == 2) ...[
                        // ========================================================
                        // STEP 2: Verification Details & Date
                        // ========================================================
                        Text(
                          "Step 2: Verification & Protection",
                          style:
                              AppTypography.serifHeading(context, fontSize: 22),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isLost
                              ? "Specify secret identifying marks to verify ownership when someone claims it."
                              : "Set a question only the legitimate owner would know.",
                          style: AppTypography.sansSecondary(context,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          isLost
                              ? "IDENTIFYING MARKS / SECRET DETAILS"
                              : "OWNERSHIP VERIFICATION QUESTION",
                          style: AppTypography.uppercaseLabel(context,
                              fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: containerFill,
                            borderRadius:
                                BorderRadius.circular(AppRadius.input),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: TextFormField(
                            controller: _questionController,
                            maxLines: 3,
                            style:
                                AppTypography.sansBody(context, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: isLost
                                  ? "e.g. Small scuff on the coin pocket, contains gym pass..."
                                  : "e.g. What color is the zipper pull or keychain tag?",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                            onChanged: (val) {
                              ctx
                                  .read<InsertItemBloc>()
                                  .add(InsertItemEvent.questionChanged(val));
                            },
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Back & Next Buttons Row
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep = 1;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                  ),
                                ),
                                child: const Text("Back"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep = 3;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mintColor,
                                  foregroundColor: isDark
                                      ? const Color(0xFF0B101D)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Next: Review",
                                      style: AppTypography.sansBold(
                                        context,
                                        fontSize: 16,
                                        color: isDark
                                            ? const Color(0xFF0B101D)
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward_rounded,
                                        size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // ========================================================
                        // STEP 3: Review & Publish
                        // ========================================================
                        Text(
                          "Step 3: Review Report",
                          style:
                              AppTypography.serifHeading(context, fontSize: 22),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Verify your details before broadcasting to the neighbourhood.",
                          style: AppTypography.sansSecondary(context,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 20),

                        // Summary Review Card
                        Container(
                          decoration: BoxDecoration(
                            color: containerFill,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isLost ? urgentColor : mintColor,
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.badge),
                                    ),
                                    child: Text(
                                      isLost ? "LOST REPORT" : "FOUND REPORT",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _titleController.text.isNotEmpty
                                    ? _titleController.text
                                    : "Your item title",
                                style: AppTypography.serifHeading(context,
                                    fontSize: 22),
                              ),
                              const SizedBox(height: 10),
                              _buildReviewRow(Icons.local_offer_outlined,
                                  "Category", _selectedCategoryName, context),
                              _buildReviewRow(Icons.location_on_outlined,
                                  "Location", _locationDisplay, context),
                              if (_selectedCategoryId == 2)
                                _buildReviewRow(
                                  Icons.devices_rounded,
                                  _selectedElectronicsDeviceType == "phone"
                                      ? "IMEI"
                                      : "SSID Number",
                                  _electronicsIdentifierController.text,
                                  context,
                                ),
                              if (_questionController.text.isNotEmpty)
                                _buildReviewRow(
                                    Icons.security_rounded,
                                    "Verification",
                                    _questionController.text,
                                    context),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Back & Publish Buttons
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep = 2;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                  ),
                                ),
                                child: const Text("Back"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: state.isSubmitting
                                    ? null
                                    : () {
                                        if (_selectedCategoryId == 2 &&
                                            _electronicsIdentifierController
                                                .text
                                                .trim()
                                                .isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                _selectedElectronicsDeviceType ==
                                                        "phone"
                                                    ? "Please enter the phone's IMEI"
                                                    : "Please enter the laptop's SSID number",
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        ctx.read<InsertItemBloc>().submit(
                                              electronicsDeviceType:
                                                  _selectedCategoryId == 2
                                                      ? _selectedElectronicsDeviceType
                                                      : null,
                                              electronicsIdentifier:
                                                  _selectedCategoryId == 2
                                                      ? _electronicsIdentifierController
                                                          .text
                                                      : null,
                                              locationLabel: _locationDisplay ==
                                                      'Select a location'
                                                  ? null
                                                  : _locationDisplay,
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mintColor,
                                  foregroundColor: isDark
                                      ? const Color(0xFF0B101D)
                                      : Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                  ),
                                ),
                                child: state.isSubmitting
                                    ? const CustomCircularProgress(
                                        size: 22, color: Colors.white)
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Publish Report",
                                            style: AppTypography.sansBold(
                                              context,
                                              fontSize: 16,
                                              color: isDark
                                                  ? const Color(0xFF0B101D)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewRow(
      IconData icon, String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 16,
              color:
                  Theme.of(context).extension<CustomColors>()?.primaryAccent),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: AppTypography.sansSecondary(context, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.sansBold(context, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadZone(
    BuildContext context,
    BuildContext blocContext,
    InsertItemState state,
    Color mintColor,
    Color borderColor,
    Color secondaryTextColor,
  ) {
    return GestureDetector(
      onTap: () => _showMediaPickerSheet(blocContext),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: mintColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: mintColor.withOpacity(0.4),
            width: 1.6,
            style: BorderStyle.solid,
          ),
        ),
        child: state.imagePath != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        File(state.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () {
                          blocContext
                              .read<InsertItemBloc>()
                              .add(const InsertItemEvent.imageDeleted());
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: mintColor.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_rounded,
                          size: 28, color: mintColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Add photos",
                      style: AppTypography.sansBold(context, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Up to 4 · JPG or PNG",
                      style: AppTypography.sansSecondary(context,
                          fontSize: 12, color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildItemTypeToggle(
    BuildContext context,
    BuildContext blocContext,
    bool isLost,
    Color mintColor,
    Color urgentColor,
    Color borderColor,
  ) {
    return Row(
      children: [
        // "Lost" Toggle Pill
        Expanded(
          child: GestureDetector(
            onTap: () {
              blocContext
                  .read<InsertItemBloc>()
                  .add(const InsertItemEvent.typeChanged(ItemType.lost));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              decoration: BoxDecoration(
                color: isLost ? urgentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: isLost ? urgentColor : borderColor,
                  width: 1.4,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: isLost ? Colors.white : borderColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Lost",
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 15,
                        color: isLost ? Colors.white : borderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // "Found" Toggle Pill
        Expanded(
          child: GestureDetector(
            onTap: () {
              blocContext
                  .read<InsertItemBloc>()
                  .add(const InsertItemEvent.typeChanged(ItemType.found));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              decoration: BoxDecoration(
                color: !isLost ? mintColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: !isLost ? mintColor : borderColor,
                  width: 1.4,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: !isLost
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF0B101D)
                              : Colors.white)
                          : borderColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Found",
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 15,
                        color: !isLost
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF0B101D)
                                : Colors.white)
                            : borderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InsertItemScreenArguments {
  final bool isNewItemLost;
  final String? draftId;
  final Map<String, dynamic>? draftData;

  const InsertItemScreenArguments({
    required this.isNewItemLost,
    this.draftId,
    this.draftData,
  });
}
