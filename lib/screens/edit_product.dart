import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/provider/Products.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  static const String routeName = "/edit-product";

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgURLController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', desc: '', price: 0, imgUrl: '');
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {'title': '', 'desc': '', 'price': '', 'imgURL': ''};

  void _updateImgURL() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (!_imgURLController.text.startsWith('http') &&
              !_imgURLController.text.startsWith('https') ||
          !_imgURLController.text.endsWith('.png') &&
              !_imgURLController.text.endsWith('.jpg') &&
              !_imgURLController.text.endsWith('jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prdId = ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct =
          Provider.of<Products>(context, listen: false).findById(prdId);
      _initValues = {
        'title': _editedProduct.title,
        'desc': _editedProduct.desc,
        'price': _editedProduct.price.toString(),
        'imgURL': ''
      };
      _imgURLController.text = _editedProduct.imgUrl;
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImgURL);
    // TODO: implement initState
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateExistingProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: value!,
                          desc: _editedProduct.desc,
                          price: _editedProduct.price,
                          imgUrl: _editedProduct.imgUrl);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please provide a value.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Price"),
                    initialValue: _initValues['price'],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_descFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          desc: _editedProduct.desc,
                          price: double.parse(value!),
                          imgUrl: _editedProduct.imgUrl);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a price";
                      }
                      if (double.tryParse(value) == null) {
                        return "please enter a valid number";
                      }
                      if (double.parse(value) <= 0) {
                        return " please enter a number greater than zero";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['desc'],
                    decoration: InputDecoration(labelText: "Desc"),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          desc: value!,
                          price: _editedProduct.price,
                          imgUrl: _editedProduct.imgUrl);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a desc";
                      }
                      if (value.length < 10) {
                        return "please enter a valid desc";
                      }
                      if (value.length <= 0) {
                        return " Should be at least 10 charactors";
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8, right: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imgURLController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(
                                  _imgURLController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imgURLController,
                          focusNode: _imgUrlFocusNode,
                          onFieldSubmitted: (_) => _saveForm(),
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFav: _editedProduct.isFav,
                                title: _editedProduct.title,
                                desc: _editedProduct.desc,
                                price: _editedProduct.price,
                                imgUrl: value!);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter an image url";
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith(('https'))) {
                              return "please enter valid URL";
                            }
                            if (value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('jpeg')) {
                              return "please enter valid URL";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateImgURL);
    _descFocusNode.dispose();
    _priceFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }
}
