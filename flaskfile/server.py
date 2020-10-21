from werkzeug.utils import secure_filename
from flask import Flask,render_template,jsonify,request,url_for,send_from_directory
import time
import os
import base64
 
app = Flask(__name__)
UPLOAD_FOLDER='upload'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
basedir = os.path.abspath(os.path.dirname(__file__))
ALLOWED_EXTENSIONS = set(['txt','png','jpg','xls','JPG','PNG','xlsx','gif','GIF','zip'])
 
# 用于判断文件后缀
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.',1)[1] in ALLOWED_EXTENSIONS
 
# 用于测试上传，稍后用到
@app.route('/test/upload')
def upload_test():
    return render_template('upload.html')
 
# 上传文件
@app.route('/upload',methods=['POST'],strict_slashes=False)
def api_upload():
    file_dir=os.path.join(basedir,app.config['UPLOAD_FOLDER'])
    if not os.path.exists(file_dir):
        os.makedirs(file_dir)
    f=request.files["myfile"]  # 从表单的file字段获取文件，myfile为该表单的name值
    #f.save("read.jpg")
    fname = request.form["name"]
    if f and allowed_file(fname):  # 判断是否是允许上传的文件类型
        f.save(os.path.join(file_dir,fname))  #保存文件到upload目录 
        print(url_for('uploaded_file',filename=fname))
        return jsonify({"succeed":'True',"msg":"upload succeed"})
    else:
        return jsonify({"succeed":'False',"msg":"upload failed"})

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5555)