import { RouterProvider, createBrowserRouter } from 'react-router-dom';
import { SnackbarProvider } from 'notistack';

import { AuthProvider } from './auth/useLogin';
import SigmaLayout from './components/SigmaLayout';
import DMaicDashboard from './components/DMaicDashboard';

import './App.css';

const router = createBrowserRouter([
  {
    path: "/",
    element: <SigmaLayout />,
    children: [
      { path: "/", element: <DMaicDashboard /> },
      { path: "/dashboard", element: <DMaicDashboard /> },
      { path: "/dmaic", element: <DMaicDashboard /> },
      { path: "/control-charts", element: <DMaicDashboard /> },
      { path: "/process-capability", element: <DMaicDashboard /> }
    ],
  },
]);

const App = () => (
    <AuthProvider>
      <SnackbarProvider />
      <RouterProvider router={router} />
    </AuthProvider>
  )

export default App;
