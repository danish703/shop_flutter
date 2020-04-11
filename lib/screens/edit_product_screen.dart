import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/configration/checkinternet.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefoucusNode = FocusNode();
  final _descriptionfoucusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);
  var _isInit = true;
  var _isLoading = false;
  var _internetdialog = true;

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  @override
  void dispose() {
    _pricefoucusNode.dispose();
    _descriptionfoucusNode.dispose();
    _imageController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': ''
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageController.text.startsWith('http') &&
          !_imageController.text.startsWith('https')) {
        return;
      }
      if (!_imageController.text.endsWith('.png') &&
          !_imageController.text.endsWith('.jpg') &&
          !_imageController.text.endsWith('.jpeg') &&
          !_imageController.text.endsWith('.gif')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
      //_internetdialog = !checkinternet();
    });
    _form.currentState.save();
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Something went wrong"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("ok"))
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Something went wrong"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("ok"))
                  ],
                ));
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: _initValues['title'],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the title";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefoucusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: _initValues['price'],
                        textInputAction: TextInputAction.next,
                        focusNode: _pricefoucusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please enter the price";
                          }
                          if (double.tryParse(value) == null) {
                            return "please enter the valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "please enter the value greater than zero";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                          );
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfoucusNode);
                        },
                        keyboardType: TextInputType.number),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        initialValue: _initValues['description'],
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the description";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                        focusNode: _descriptionfoucusNode,
                        keyboardType: TextInputType.multiline),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          height: 100,
                          width: 100,
                          child: _imageController.text.isEmpty
                              ? Text("Enter URL")
                              : FittedBox(
                                  child: Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter the an image url";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "please enter the valid url";
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.gif')) {
                                return "please enter the valid image url";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
