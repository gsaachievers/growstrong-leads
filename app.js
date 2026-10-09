import {db,configured,value,show} from './common.js';
const form=document.getElementById('leadForm');
const url=new URL('index.html',location.href);url.search='';url.hash='';
const formUrl=url.href;
// QR image is generated using a public QR image endpoint. URL only; no customer data sent.
const qrSrc='https://api.qrserver.com/v1/create-qr-code/?size=300x300&data='+encodeURIComponent(formUrl);
document.getElementById('qr').src=qrSrc;document.getElementById('qrUrl').textContent=formUrl;
document.getElementById('downloadQr').onclick=()=>{window.open(qrSrc,'_blank','noopener,noreferrer')};
const requestedCenter=new URLSearchParams(location.search).get('center');if(['Lucknow','Greater Noida West'].includes(requestedCenter))document.getElementById('center').value=requestedCenter;
form.addEventListener('submit',async e=>{e.preventDefault();if(!configured){show('message','Setup needed: add your Supabase URL and publishable key in config.js.',true);return}
const btn=document.getElementById('submitBtn');btn.disabled=true;
const lead={parent_name:value('parent'),mobile:value('mobile'),child_name:value('child')||null,child_age:value('age')?Number(value('age')):null,center:value('center'),program:value('program'),source:value('source'),notes:value('notes')||null};
try{const {error}=await db.from('gsa_leads').insert(lead);if(error)throw error;form.reset();show('message','Thank you! Your enquiry has been submitted successfully.')}catch(err){show('message','Unable to submit: '+err.message,true)}finally{btn.disabled=false}});
