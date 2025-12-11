// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../notification.dart';
import '../base.dart';
import '../../authenticator.dart';
import '../../api.dart';
import '../../model/shop_item.dart';
import '../../server.dart';

class ShopItemEditPage extends StatefulWidget {
  final ShopItem? item;

  const ShopItemEditPage({super.key, this.item});

  @override
  State<ShopItemEditPage> createState() => _ShopItemEditPageState();
}

class _ShopItemEditPageState extends PageBaseState<ShopItemEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _costController;
  late TextEditingController _imageUrlController;
  late bool _isAvailable;
  bool _isUploading = false;
  bool _isSaving = false;

  // Error states
  bool _titleError = false;
  bool _costError = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title);
    _descriptionController = TextEditingController(text: widget.item?.description);
    _costController = TextEditingController(text: widget.item?.cost.toString());
    _imageUrlController = TextEditingController(text: widget.item?.imageUrl);
    _isAvailable = widget.item?.isAvailable ?? true;

    // Add listeners to clear errors when user types
    _titleController.addListener(() {
      if (_titleError && _titleController.text.isNotEmpty) {
        setState(() => _titleError = false);
      }
    });
    _costController.addListener(() {
      if (_costError && _costController.text.isNotEmpty) {
        setState(() => _costError = false);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  String get pageTitle => widget.item == null ? localizations.addItem : localizations.editItem;

  @override
  bool get goBackButtonInAppBar => true;

  Future<void> _pickAndUploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        final url = await apiService.uploadFile(result.files.single);
        if (url != null) {
          // Prepend server URL if it's a relative path
          final fullUrl = url.startsWith('http') ? url : '${await getServerUrl()}$url';
          setState(() {
            _imageUrlController.text = fullUrl;
          });
        } else if (mounted) {
          showErrorNotification('Upload failed', context: context);
        }
      } catch (e) {
        if (mounted) {
          showErrorNotification('Upload failed: $e', context: context);
        }
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _saveItem() async {
    final title = _titleController.text.trim();
    final costText = _costController.text.trim();
    final cost = int.tryParse(costText);

    // Validate required fields
    bool hasError = false;
    if (title.isEmpty) {
      setState(() => _titleError = true);
      hasError = true;
    }
    if (costText.isEmpty || cost == null || cost <= 0) {
      setState(() => _costError = true);
      hasError = true;
    }

    if (hasError) {
      showErrorNotification(localizations.pleaseFillRequiredFields, context: context);
      return;
    }

    setState(() => _isSaving = true);

    final newItem = ShopItem(
      id: widget.item?.id ?? 0,
      title: title,
      description: _descriptionController.text.trim(),
      cost: cost!,
      imageUrl: _imageUrlController.text.trim(),
      isAvailable: _isAvailable,
      creatorId: 0, // Server will handle this
    );

    try {
      final result = widget.item == null 
        ? await apiService.createShopItem(newItem)
        : await apiService.updateShopItem(newItem);
      
      if (mounted) {
        if (result != null) {
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          showErrorNotification('Failed to save item', context: context);
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification('Failed to save item: $e', context: context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '${localizations.title} *',
              errorText: _titleError ? localizations.titleRequired : null,
              border: OutlineInputBorder(),
              filled: true,
              fillColor: _titleError ? Colors.red.withOpacity(0.1) : null,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: localizations.description,
              border: OutlineInputBorder(),
              filled: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _costController,
            decoration: InputDecoration(
              labelText: '${localizations.costPoints} *',
              errorText: _costError ? localizations.costRequired : null,
              border: OutlineInputBorder(),
              filled: true,
              fillColor: _costError ? Colors.red.withOpacity(0.1) : null,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: localizations.imageUrl,
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  onChanged: (_) => setState(() {}), // Refresh preview
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: Text(localizations.upload),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Image Preview
          if (_imageUrlController.text.isNotEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.contain,
                  headers: auth.token != null
                      ? {'Authorization': 'Bearer ${auth.token}'}
                      : null,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Failed to load image'),
                      ],
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(localizations.available),
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: Text(localizations.cancel),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveItem,
                child: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(localizations.save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
